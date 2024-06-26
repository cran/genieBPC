% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/synapse_version.R
\name{synapse_version}
\alias{synapse_version}
\title{Return list of available GENIE BPC data releases}
\usage{
synapse_version(cohort = NULL, most_recent = FALSE)
}
\arguments{
\item{cohort}{Vector specifying the cohort(s) of interest. Cohorts must be
one of "NSCLC" (Non-Small Cell Lung Cancer), "CRC" (Colorectal Cancer), or
"BrCa" (Breast Cancer), "PANC" (Pancreatic Cancer), "Prostate" (Prostate Cancer),
and "BLADDER" (Bladder Cancer).}

\item{most_recent}{Indicates whether the function will return only the most
recent version number for each cohort (`most_recent` = TRUE) or all
available version numbers for each cohort (`most_recent`= FALSE)}
}
\value{
Returns a table containing the available versions for each cohort.
  Consortium releases are restricted to GENIE BPC consortium members.
}
\description{
GENIE BPC data are updated periodically to add variables and reflect
additional data cleaning. Each time the data are updated the data release
version number is incremented. The `synapse_version()` function will get
available version numbers for each cohort to help the user determine what is
the most recent version for each cohort.
}
\details{
Specifies the version numbers available for each cancer cohort. Version
numbers are specified as part of the call to `pull_data_synapse()`.
}
\examples{
synapse_version()
synapse_version(most_recent = TRUE)
}
