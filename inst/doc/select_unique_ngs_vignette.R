## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", warning = F, message = F
)

# exit if user doesn't have synapser, a log in, or access to data.
if (genieBPC:::.is_connected_to_genie(pat = Sys.getenv("SYNAPSE_PAT")) == FALSE){
  knitr::knit_exit()
}

