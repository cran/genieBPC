## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  message = FALSE
)

# exit if user doesn't have synapser, a log in, or access to data. 
if (genieBPC:::.is_connected_to_genie() == FALSE){
  knitr::knit_exit()
}

