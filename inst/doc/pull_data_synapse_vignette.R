## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

# exit if user doesn't have synapser, a log in, or access to data.
if (genieBPC:::.is_connected_to_genie() == FALSE){
  knitr::knit_exit()
}

## ---- include=FALSE, eval=genieBPC:::.is_connected_to_genie()-----------------
library(genieBPC)
library(dplyr)
library(tibble)
library(magrittr)
library(gt)

set_synapse_credentials()

## ----echo = FALSE, warning = FALSE, message = FALSE, eval=genieBPC:::.is_connected_to_genie()----
tibble::tribble(
  ~Argument,       ~Description,
  "`cohort`",       "Vector or list specifying the cohort(s) of interest. Must be one of 'NSCLC' (Non-Small Cell Lung Cancer), 'CRC' (Colorectal Cancer), 'BrCa' (Breast Cancer), 'BLADDER' (Bladder Cancer), 'PANC' (Pancreatic Cancer), or 'Prostate' (Prostate Cancer)",
  "`version`",        "Vector specifying the version of the data. Must be one of the following: 'v1.1-consortium', 'v1.2-consortium', 'v2.1-consortium', 'v2.0-public'. When entering multiple cohorts, the order of the version numbers corresponds to the order that the cohorts are specified; the cohort and version number must be in the same order in order to pull the correct data.",
  "`download_location`",        "If `NULL` (default), data will be returned as a list of dataframes with requested data as list items. Otherwise, specify a folder path to have data automatically downloaded there. When a path is specified, data are not read into the R environment.",
  "`username`",        "Synapse username",
  "`password`",        "Synapse password"
) %>%
  gt::gt() %>%
  gt::fmt_markdown(columns = c(Argument)) %>%
  gt::tab_options(table.font.size = 'small',
                  data_row.padding = gt::px(1),
                  summary_row.padding = gt::px(1),
                  grand_summary_row.padding = gt::px(1),
                  footnotes.padding = gt::px(1),
                  source_notes.padding = gt::px(1),
                  row_group.padding = gt::px(1))

## ---- eval = FALSE------------------------------------------------------------
#  nsclc_2_0 = pull_data_synapse("NSCLC", version = "v2.0-public")

## ---- include = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_2_0 = pull_data_synapse("NSCLC", version = "v2.0-public")

## ---- include = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
ls(nsclc_2_0$NSCLC_v2.0) %>% 
  as.data.frame() %>% 
  mutate(clinical_vs_genomic = case_when(. %in% c("cna", "fusions",
                                                  "mutations_extended") ~ "Genomic Data",
                                         TRUE ~ "Clinical Data")) %>% 
  gt::gt() %>% 
  gt::cols_label(.data = .,
                 `.` = md("**Datasets Returned**"),
             clinical_vs_genomic = md("**Clinical/Genomic Data**"))

## ---- eval = FALSE------------------------------------------------------------
#  pull_data_synapse(c("NSCLC", "CRC"),
#                    version = c("v2.2-consortium","v1.3-consortium"))

## ---- eval = FALSE------------------------------------------------------------
#  pull_data_synapse(c("NSCLC", "CRC"),
#                    version = c("v1.2-consortium", "v1.1-consortium"))

