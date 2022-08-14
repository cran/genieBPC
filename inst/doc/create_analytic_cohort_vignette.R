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

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
library(genieBPC)

set_synapse_credentials()

## ---- include = FALSE---------------------------------------------------------
library(gt)
library(dplyr)
library(magrittr)
library(tibble)

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

## ---- include = FALSE---------------------------------------------------------
tbl_arguments = tibble::tribble(
  ~Argument,       ~Description,
  "`data_synapse`",       "The item from the nested list returned from pull_data_synapse() corresponding to the cancer cohort of interest.",
  "`index_ca_seq`",       "Index cancer sequence. Default is 1, indicating the patient's first index cancer. The index cancer is also referred to as the BPC Project cancer in the GENIE BPC Analytic Data Guide; this is the cancer that met the eligibility criteria for the project and was selected at random for PRISSMM phenomic data curation. Specifying multiple index cancer sequences, e.g. index_ca_seq = c(1, 2), will return index cancers to patients with 1 index cancer and will return the first AND second index cancers to patients with multiple.",
  "`institution`",        "GENIE BPC participating institution. Must be one of 'DFCI', 'MSK', 'UHN', or 'VICC' for    NSCLC cohorts; must be one of 'DFCI', 'MSK', 'VICC' for CRC and BrCa. Default selection is all institutions. This parameter corresponds to the variable `institution` in the Analytic Data Guide.",
  "`stage_dx`",        "Stage at diagnosis. Must be one of 'Stage I', 'Stage II', 'Stage III', 'Stage I-III NOS', 'Stage IV'. Default selection is all stages. This parameter corresponds to the variable `stage_dx` in the
 Analytic Data Guide.",
  "`histology`",        "Cancer histology. For all cancer cohorts except for BrCa
 (breast cancer), this parameter corresponds to the variable `ca_hist_adeno_squamous` and must be one of 'Adenocarcinoma', 'Squamous cell', 'Sarcoma', 'Small cell carcinoma', 'Carcinoma', 'Other histologies/mixed tumor'. For BrCa, this parameter corresponds to the variable `ca_hist_brca` and must be one of 'Invasive lobular carcinoma', 'Invasive ductal carcinoma', 'Other histology'. Default selection is all histologies.",
  "`regimen_drugs`",        "Vector with names of drugs in cancer-directed regimen, separated by a comma. For example, to specify a regimen consisting of Carboplatin and Pemetrexed, specify regimen_drugs = 'Carboplatin, Pemetrexed'. Acceptable values are found in the `drug_regimen_list` dataset provided with this package. This parameter corresponds to the variable `regimen_drugs` in the Analytic Data Guide.",
  "`regimen_type`",        "Indicates whether the regimen(s) specified in `regimen_drugs` indicates the exact regimen to return, or if regimens containing the drugs listed in `regimen_drugs` should be returned. Must be one of 'Exact' or 'Containing'. The default is 'Exact'.",
  "`regimen_order`",        "Order of cancer-directed regimen. If multiple drugs are specified, `regimen_order` indicates the regimen order for all drugs; different values of `regimen_order` cannot be specified for different drug regimen. If multiple values are specified, e.g. c(1, 2), then drug regimens that met either order criteria are returned.",
  "`regimen_order_type`",        "Specifies whether the `regimen_order` parameter refers to the order of receipt of the drug regimen within the cancer diagnosis (across all other drug regimens; 'within cancer') or the order of receipt of the drug regimen within the times that that drug regimen was administered (e.g. the first time carboplatin pemetrexed was received, out of all times that the patient received carboplatin pemetrexed; 'within regimen'). Acceptable values are 'within cancer' and 'within regimen'.",
  "`return_summary`",        "Specifies whether a summary table for the cohort is returned. Default is FALSE. The `gtsummary` package is required to return a summary table."
) %>%
  gt::gt() %>%
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

## ---- echo = FALSE------------------------------------------------------------
tbl_arguments

## ---- results = 'hide', eval = FALSE------------------------------------------
#  create_analytic_cohort(data_synapse = genieBPC::nsclc_test_data)

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
nsclc_2_0 <- pull_data_synapse("NSCLC", version = "v2.0-public")

## ---- eval=genieBPC:::.is_connected_to_genie()--------------------------------
nsclc_stg_iv_adeno <- create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0, 
                                             stage_dx = "Stage IV", 
                                             histology = "Adenocarcinoma")

ls(nsclc_stg_iv_adeno)

## ---- results = 'hide', eval=genieBPC:::.is_connected_to_genie()--------------
create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0,
                       regimen_drugs = c("Cisplatin, Pemetrexed Disodium","Cisplatin, Etoposide"),
                       regimen_order = 1,
                       regimen_order_type = "within cancer")

## ---- warning = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_cisplatin_pem_any = create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0,
                                                 regimen_drugs = c("Cisplatin, Pemetrexed Disodium"),
                                                 regimen_order = 1,
                                                 regimen_order_type = "within regimen",
                                                 return_summary = TRUE)

## ---- warning = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_cisplatin_pem_any$tbl_overall_summary

## ---- warning = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_cisplatin_pem_any$tbl_cohort

## ---- warning = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_cisplatin_pem_any$tbl_drugs

## ---- warning = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
nsclc_cisplatin_pem_any$tbl_ngs

