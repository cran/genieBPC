# Create Package Environment ---------------------------------------------------
# set environment in which to store URL variable that persists for that session
genieBPC_env <- rlang::new_environment()


# User-facing Authorization Functions -----------------------------------------

#' Connect to 'Synapse' API
#'
#' This function sets 'Synapse' credentials for the user's current session.
#'
#' To access data, users must have a valid 'Synapse' account with permission to
#' access the data set and they must have accepted any necessary 'Terms of Use'.
#' Users must authenticate themselves in their current R session.
#' (See README 'Data Access and Authentication' at https://genie-bpc.github.io/genieBPC/ for details).
#' To set your 'Synapse' credentials during each session, call:
#'  `set_synapse_credentials(username = "your_username", password = "your_password")`.
#'
#' If your credentials are stored as environmental variables, you do not need to call
#' `set_synapse_credentials()` explicitly each session. To store authentication
#' information in your environmental variables, add the following to your
#' .Renviron file, then restart your R session
#' (tip: you can use `usethis::edit_r_environ()` to easily open/edit this file):
#'
#' \itemize{
#'    \item `SYNAPSE_USERNAME = <your-username>`
#'    \item `SYNAPSE_PASSWORD = <your-password>`
#'    }
#'
#' Alternatively, you can pass your username and password to each individual
#' data pull function if preferred, although it is recommended that you manage
#' your passwords outside of your scripts for security purposes.
#'
#' @param username 'Synapse' username. If NULL, package will search
#' environmental variables for `SYNAPSE_USERNAME`.
#' @param password 'Synapse' password. If NULL, package will search
#' environmental variables for `SYNAPSE_PASSWORD`.

#' @return A success message if you credentials are valid for 'Synapse'
#' platform; otherwise an error
#'
#' @author Karissa Whiting
#' @export
#'
#' @examples
#' \dontrun{
#' set_synapse_credentials(
#'   username = "your-username",
#'   password = "your-password"
#' )
#' }
#'
set_synapse_credentials <- function(username = NULL, password = NULL) {

  # if no args passed, check sys environment
  resolved_username <- username %||% Sys.getenv("SYNAPSE_USERNAME", unset = NA)
  resolved_password <- password %||% Sys.getenv("SYNAPSE_PASSWORD", unset = NA)

  switch(any(is.na(c(resolved_username, resolved_password))),
    {
      rlang::abort("No `username` or `password` specified and no
                   `SYNAPSE_USERNAME` or `SYNAPSE_PASSWORD` in `.Renviron`.
                   Try specifying `username` or `password` arguments or use
                   `usethis::edit_r_environ()` to add to your global variables")
    }
  )

  # assign credentials to package environment
  assign("username",
    value = resolved_username,
    envir = genieBPC_env
  )

  assign("password",
    value = resolved_password,
    envir = genieBPC_env
  )

  # check the credentials with a call
  x <- .get_synapse_token(
    username = resolved_username,
    password = resolved_password
  )

  cli::cli_alert_success("You are now connected to 'Synapse' as
                         {.field {resolved_username}} for this R session!")
}

#' Check Access to GENIE Data
#'
#' @param username 'Synapse' username. If NULL, package will search package
#'   environment for "username". If not found, package will look in
#'   environmental variables for `SYNAPSE_USERNAME`.
#' @param password 'Synapse' password. If NULL, package will search package
#'   environment for "password". If not found package will search environmental
#'   variables for `SYNAPSE_PASSWORD`.
#'
#' @return A success message if you are able to access GENIE BPC data; otherwise
#'   an error
#' @author Karissa Whiting
#' @export
#'
#' @examples
#' \dontrun{
#' # if credentials are saved:
#' check_genie_access()
#' }
check_genie_access <- function(username = NULL, password = NULL) {

  # first get token
  token <- .get_synapse_token(username = username, password = password)

  # now do genie-specific test query
  query_url <- "https://repo-prod.prod.sagebase.org/repo/v1/entity/syn26948075/bundle2"

  requested_objects <- jsonlite::toJSON(list(
    "includeEntity" = TRUE,
    "includeAnnotations" = TRUE,
    "includeFileHandles" = TRUE,
    "includeRestrictionInformation" = TRUE
  ),
  pretty = TRUE, auto_unbox = TRUE
  )

  res <- httr::POST(
    url = query_url,
    body = requested_objects,
    httr::add_headers(
      Authorization =
        paste("Bearer ", token, sep = "")
    ),
    httr::content_type("application/json")
  )


  httr::stop_for_status(res, "access GENIE data in 'Synapse'.
                        Check that you have permission to view this data")
  cli::cli_alert_success("{httr::http_status(res)$message}:
                         You are successfully connected to the GENIE database!")
}


#  Utility Functions for Authorization -----------------------------------------

#' Get an object from the genieBPC package environment (`genieBPC_env`)
#'
#' @param thing_to_check
#'
#' @return The object
#' @keywords internal
#' @export
#' @examples
#' \dontrun{
#' .get_env("username")
#' }
.get_env <- function(thing_to_check) {
  thing <- tryCatch(
    {
      get(thing_to_check,
        envir = genieBPC_env
      )
    },
    error = function(e) {
      return(NULL)
    }
  )
  thing
}

#' Retrieve a synapse token using username and password
#'
#' @inheritParams check_genie_access
#'
#' @return a 'Synapse' token
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' .get_synapse_token(username = "test", password = "test")
#' }
.get_synapse_token <- function(username = NULL, password = NULL) {
  resolved_username <- username %||% .get_env("username") %||%
    Sys.getenv("SYNAPSE_USERNAME", unset = NA)

  resolved_password <- password %||% .get_env("password") %||%
    Sys.getenv("SYNAPSE_PASSWORD", unset = NA)


  # ensure a username and password is supplied---------------------------------
  switch(any(is.na(c(resolved_username, resolved_password))),
    cli::cli_abort("No credentials found. Have you authenticated yourself?
                   Use {.code set_synapse_credentials()} to set credentials for this session, or pass a {.code username} and {.code password}
                   (see README:'Data Access & Authentication' for details on authentication).")
  )

  # query to get token --------------------------------------------------------
  requested_objects <- jsonlite::toJSON(list(
    "email" = resolved_username,
    "password" = resolved_password
  ), pretty = TRUE, auto_unbox = TRUE)

  resp <- httr::POST("https://auth-prod.prod.sagebase.org/auth/v1/session",
    body = requested_objects,
    encode = "json",
    httr::add_headers(`accept` = "application/json"),
    httr::content_type("application/json")
  )

  token <- httr::content(resp, "parsed")$sessionToken

  token %||%
    cli::cli_abort("There was an error authenticating your
                   username ({resolved_username}) or password.
                   Please make sure you can login to the 'Synapse' website
                   with the given credentials.")

  return(token)
}

#' Check Synapse Login Status & Ability to Access Data
#'
#' The `.is_connected_to_genie()` function assesses whether the
#' user is logged into 'Synapse' and confirms whether the
#' user has permission to access the GENIE BPC data. It returns TRUE or FALSE
#' @keywords internal
#' @return Returns message indicating user is logged into
#' 'Synapse' and has permission to access the GENIE BPC data.
#' @export
#' @examples
#' .is_connected_to_genie()
.is_connected_to_genie <- function() {
  tryCatch(check_genie_access(),
    error = function(e) FALSE,
    message = function(m) TRUE
  )
}
