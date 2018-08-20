rm(list = ls())
library(maps) # conflicts with purrr
library(MASS)
library(wordbankr) # all
library(langcog)
library(directlabels)
library(forcats)
library(DT)
library(quantregGrowth)
library(feather)
library(ggrepel)
library(ggdendro) # item consistency
library(rms)
library(metafor)
library(broom)
library(gridExtra)
library(modelr) # ch 7b
library(binom) # data
library(lme4)
library(ggfortify)
library(rlang)
library(glue)
library(jsonlite) # appendix data
library(widyr) # gesture
library(knitr)
library(multidplyr) # for item demographics
library(parallel) # for item demographics
library(viridis) # for style
library(mirtCAT) # style, psychometrics, vocab
library(ggthemes)
library(tidyverse) # keep tidyverse last to prevent conflicts

source("helper/predictQR.R")
source("helper/stats_funs.R")

local_data <- TRUE

if (local_data) {
  instruments <- feather::read_feather("data/instruments.feather")
  admins <- feather::read_feather("data/admins.feather")
  items <- feather::read_feather("data/items.feather")
} else {
  instruments <- wordbankr::get_instruments()
  feather::write_feather(instruments, "data/instruments.feather")
  admins <- wordbankr::get_administration_data(original_ids = TRUE)
  feather::write_feather(admins, "data/admins.feather")
  items <- wordbankr::get_item_data()
  feather::write_feather(items, "data/items.feather")
}


### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")
