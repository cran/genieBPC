## ---- include=FALSE-----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  message = FALSE,
  comment = "#>")

# exit if user doesn't have synapser, a log in, or access to data.
if (genieBPC:::.is_connected_to_genie() == FALSE){
  knitr::knit_exit()
}

## ---- include=FALSE, eval=genieBPC:::.is_connected_to_genie()-----------------
library(genieBPC)
library(dplyr)
library(ggplot2)
library(plotly)
library(gt)
library(magrittr)
library(tibble)

## ---- include = FALSE, eval=genieBPC:::.is_connected_to_genie()---------------
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
  "`data_synapse`",       "The item from the nested list returned from pull_data_synapse() corresponding to the cancer cohort of interest.",
  "`data_cohort`",       "The list returned from the `create_analytic_cohort()` function call.",
  "`max_n_regimens`",        "The number of lines of treatment displayed in the sunburst plot.") %>%
  gt::gt() %>%
  gt::tab_header(title = "`drug_regimen_sunburst()` Function Arguments") %>%
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

## ---- results = 'hide', message = FALSE, eval=genieBPC:::.is_connected_to_genie()----
nsclc_stg_iv = create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0,
                                      stage = c("Stage IV"))

nsclc_treatment = drug_regimen_sunburst(data_synapse = nsclc_2_0$NSCLC_v2.0,
                      data_cohort = nsclc_stg_iv,
                      max_n_regimens = 3)

## ---- eval=genieBPC:::.is_connected_to_genie()--------------------------------
head(nsclc_treatment$treatment_history)

## ---- fig.height=8, fig.width=8, eval=genieBPC:::.is_connected_to_genie()-----
nsclc_treatment$sunburst_plot

