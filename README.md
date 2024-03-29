
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-cmd-check](https://github.com/GENIE-BPC/genieBPC/workflows/R-cmd-check/badge.svg)](https://github.com/GENIE-BPC/genieBPC/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/genieBPC)](https://cran.r-project.org/package=genieBPC)
[![codecov](https://codecov.io/gh/GENIE-BPC/genieBPC/branch/main/graph/badge.svg?token=431LhDhF5K)](https://app.codecov.io/gh/GENIE-BPC/genieBPC)
![r-universe](https://mskcc-epi-bio.r-universe.dev/badges/genieBPC)
<!-- badges: end -->

# genieBPC <img src="man/figures/geniebpc_hex_sticker.png" align="right" height="120" /></a>

The American Association for Cancer Research Project Genomics Evidence
Neoplasia Information Exchange Biopharma Collaborative (GENIE BPC) is an
effort to aggregate comprehensive clinical data linked to genomic
sequencing data to create a pan-cancer, publicly available data
repository. These data detail clinical characteristics and drug regimen
treatment information, along with high-throughput sequencing data and
clinical outcomes, for cancer patients across multiple institutions. The
GENIE BPC data repository forms a unique observational database of
comprehensive clinical annotation with molecularly characterized tumors
that can be used to advance precision medicine research in oncology.
Linking multiple clinical and genomic datasets that vary in structure
introduces an inherent complexity for data users. Therefore, use of the
GENIE BPC data requires a rigorous process for preparing and merging the
data to build analytic models. The {genieBPC} package is a user-friendly
data processing pipeline to streamline the process for developing
analytic cohorts that are ready for clinico-genomic analyses.

## Installation

Install {genieBPC} from CRAN:

``` r
install.packages("genieBPC")
```

Install the development version of {genieBPC} with:

``` r
remotes::install_github("GENIE-BPC/genieBPC")
```

## Overview of {genieBPC} Functions

- **Data import:** `pull_data_synapse()` imports GENIE BPC data from
  ‘Synapse’ into the R environment

- **Data processing**

  - `create_analytic_cohort()` selects an analytic cohort based on
    cancer diagnosis information and/or cancer-directed drug regimen
    information  
  - `select_unique_ngs()` selects a unique next generation sequencing
    (NGS) test corresponding to the selected diagnoses

- **Data visualization:** `drug_regimen_sunburst()` creates a sunburst
  figure of drug regimen information corresponding to the selected
  diagnoses in the order that the regimens were administered

## Data Access & Authentication

Access to the GENIE BPC data release folders on ‘Synapse’ is required in
order to use this function. To obtain access:

***For public data releases:***

1.  Register for a [‘Synapse’ account](https://www.synapse.org/#).
    Accept the **Synapse account terms of use.**

2.  Navigate to the data release and request accept terms of use (e.g.,
    for the NSCLC 2.0-public data release, navigate to the [‘Synapse’
    page](https://www.synapse.org/#!Synapse:syn27056697) for the data
    release). Towards the top of the page, there is information
    including the *‘Synapse’ ID*, *DOI*, *Item count*, and *Access.*
    Next to *Access* is a link that reads *Request Access*.

3.  Select *Request Access*, review the **terms of data use** and select
    *Accept*

*Note that permissions for Synapse and permissions for each data release
are distinct. Both permissions must be accepted to successfully access
the data.*

***For consortium data releases (restricted to GENIE consortium members
& BPC pharmaceutical partners):***

1.  Register for a [‘Synapse’ account](https://www.synapse.org/#)

2.  Use [this link](https://www.synapse.org/#!Team:3399797) to access
    the GENIE BPC team list and request to join the team. Please include
    your full name and affiliation in the message before sending out the
    request.

3.  Once the request is accepted, you may access the data in the [GENIE
    Biopharma Collaborative
    projects](https://www.synapse.org/#!Synapse:syn21226493).

*Note: Please allow up to a week to review and grant access.*

***Authenticate yourself***

4.  Whether you are using public or consortium data, you will need to
    authenticate yourself at the beginning of each R session in which
    you use {genieBPC} to pull data (see `set_synapse_credentials()`),
    or store your credentials as environmental variables. See [Tutorial:
    pull_data_synapse](https://genie-bpc.github.io/genieBPC/articles/pull_data_synapse_vignette.html)
    for more details.

## Analytic Data Guides

The analytic data guides provide details on each analytic dataset and
its corresponding variables for each data release.

**Public Data Releases**

- [NSCLC v2.0-Public Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn30557304) *Released May
  2022*

- [CRC v2.0-Public Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn31751466) *Released August
  2022*

**Consortium Data Releases**  
*Note that only GENIE BPC consortium users have access to the consortium
releases.*

- [NSCLC v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn23002641)

- [NSCLC v2.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn26008058)

- [CRC v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn23764204)

- [CRC v1.2-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn26077308)

- [BrCa v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn26077313)

- [BrCa v1.2-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn32330194)

- [PANC v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn29787285)

- [PANC v1.2-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn50612821)

- [BLADDER v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn30787692)

- [Prostate v1.1-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn30148714)

- [Prostate v1.2-Consortium Analytic Data
  Guide](https://www.synapse.org/#!Synapse:syn50612204)

## Example

The following example creates an analytic cohort of patients diagnosed
with Stage IV adenocarcinoma NSCLC.

*Pull data for NSCLC version 2.0-public:*

``` r
nsclc_2_1 <- pull_data_synapse(cohort = "NSCLC", version = "v2.0-public")
```

*Select stage IV adenocarcinoma NSCLC diagnoses:*

``` r
nsclc_stg_iv_adeno <- create_analytic_cohort(data_synapse = nsclc_2_0$NSCLC_v2.0, 
                                             stage_dx = "Stage IV", 
                                             histology = "Adenocarcinoma")
```

*Select one unique metastatic lung adenocarcinoma genomic sample per
patient in the analytic cohort returned above:*

``` r
nsclc_stg_iv_adeno_unique_sample <- select_unique_ngs(
  data_cohort = nsclc_stg_iv_adeno$cohort_ngs)
```

*Create a visualization of the treatment patterns for the first 3
regimens received by patients diagnosed with stage IV adenocarcinoma:*

``` r
sunplot <- drug_regimen_sunburst(data_synapse = nsclc_2_0$NSCLC_v2.0,
                                 data_cohort = nsclc_stg_iv_adeno,
                                 max_n_regimens = 3)
```

*Example of a sunburst plot showing 3 treatment regimens, highlighting
the first treatment regimen:*

# <img src="man/figures/genieBPC_sunburst2.png" height="400" /></a>

## GENIE BPC Publications

Lavery JA, Lepisto EM, Brown S, Rizvi H, McCarthy C, LeNoue-Newton M, Yu
C, Lee J, Guo X, Yu T, Rudolph J, Sweeney S; AACR Project GENIE
Consortium, Park BH, Warner JL, Bedard PL, Riely G, Schrag D, Panageas
KS. [A Scalable Quality Assurance Process for Curating Oncology
Electronic Health Records: The Project GENIE Biopharma Collaborative
Approach.](https://ascopubs.org/doi/full/10.1200/CCI.21.00105) JCO Clin
Cancer Inform. 2022 Feb;6:e2100105. doi: 10.1200/CCI.21.00105. PMID:
35192403; PMCID: PMC8863125.

Brown S, Lavery JA, Shen R, Martin AS, Kehl KL, Sweeney SM, Lepisto EM,
Rizvi H, McCarthy CG, Schultz N, Warner JL, Park BH, Bedard PL, Riely
GJ, Schrag D, Panageas KS; AACR Project GENIE Consortium. [Implications
of Selection Bias Due to Delayed Study Entry in Clinical Genomic
Studies.](https://jamanetwork.com/journals/jamaoncology/fullarticle/2785693)
JAMA Oncol. 2022 Feb 1;8(2):287-291. doi: 10.1001/jamaoncol.2021.5153.
PMID: 34734967; PMCID: PMC9190030.

Kehl KL, Riely GJ, Lepisto EM, Lavery JA, Warner JL, LeNoue-Newton ML,
Sweeney SM, Rudolph JE, Brown S, Yu C, Bedard PL, Schrag D, Panageas KS;
American Association of Cancer Research (AACR) Project Genomics Evidence
Neoplasia Information Exchange (GENIE) Consortium. [Correlation Between
Surrogate End Points and Overall Survival in a Multi-institutional
Clinicogenomic Cohort of Patients With Non-Small Cell Lung or Colorectal
Cancer.](https://jamanetwork.com/journals/jamanetworkopen/fullarticle/2782339)
JAMA Netw Open. 2021 Jul 1;4(7):e2117547. doi:
10.1001/jamanetworkopen.2021.17547. PMID: 34309669; PMCID: PMC8314138.
