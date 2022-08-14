## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", warning = F, message = F
)

# exit if user doesn't have synapser, a log in, or access to data.
if (genieBPC:::.is_connected_to_genie() == FALSE){
  knitr::knit_exit()
}

## ---- include = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
library(genieBPC)
library(tibble)
library(magrittr)
library(dplyr)
library(gt)

gt_compact_fun <- function(x) {
  gt::tab_options(x, 
                  table.font.size = 'small',
                  data_row.padding = gt::px(1),
                  summary_row.padding = gt::px(1),
                  grand_summary_row.padding = gt::px(1),
                  footnotes.padding = gt::px(1),
                  source_notes.padding = gt::px(1),
                  row_group.padding = gt::px(1))
}

## ---- include = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
tbl_arguments = tibble::tribble(
  ~Argument,       ~Description,
  "`data_cohort`",       "Output object of the create_analytic_cohort function.",
  "`oncotree_code`",       "Character vector specifying which sample OncoTree codes to keep. See 'cpt_oncotree_code' column of data_cohort argument above to get options.",
  "`sample_type`",        "Character specifying which type of genomic sample to prioritize, options are 'Primary', 'Local' and 'Metastasis'. Default is to not select a NGS sample based on the sample type.",
  "`min_max_time`",        "Character specifying if the first or last genomic sample recorded should be kept. Options are 'min' (first) and 'max' (last).") %>%
  gt::gt() %>%
  gt::tab_header(title = "`select_unique_ngs()` Function Arguments") %>% 
  gt::fmt_markdown(columns = c(Argument)) %>%
  gt::tab_options(table.font.size = 'small',
                  data_row.padding = gt::px(1),
                  summary_row.padding = gt::px(1),
                  grand_summary_row.padding = gt::px(1),
                  footnotes.padding = gt::px(1),
                  source_notes.padding = gt::px(1),
                  row_group.padding = gt::px(1)) %>%
  gt_compact_fun()

tbl_arguments

## ---- echo = FALSE, eval=genieBPC:::.is_connected_to_genie()------------------
tbl_arguments

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
library(genieBPC)

set_synapse_credentials()

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
nsclc_2_0 = pull_data_synapse("NSCLC", version = "v2.0-public")

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
out <- create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0, 
                                             stage_dx = c("Stage IV"), 
                                             histology = "Adenocarcinoma")

samples_data <- select_unique_ngs(data_cohort = out$cohort_ngs)

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
out <- create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0,
                              regimen_drugs = c("Cisplatin, Pemetrexed Disodium", "Cisplatin, Etoposide"), 
                              regimen_order = 1, regimen_order_type = "within regimen")

samples_data <- select_unique_ngs(data_cohort = out$cohort_ngs,
                                  oncotree_code = "LUAD", 
                                  sample_type = "Metastasis", 
                                  min_max_time = "max")

