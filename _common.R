rm(list = ls())

library(MASS)
library(wordbankr)
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
library(maps) # methods
library(boot)

# to deal with font issue perhaps?
library(extrafont)
loadfonts()

library(robustbase) # appendix-aoa
library(arm) # appendix-aoa
library(rstan) # appendix-aoa

library(knitr)
library(langcog)
library(tidyverse) # keep tidyverse last to prevent conflicts


opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  echo = FALSE,
  cache.lazy = FALSE,
  fig.align = "center",
  fig.show = "hold"
)

theme_set(theme_mikabr())
.font <- theme_mikabr()$text$family

source("helper/predictQR.R")
source("helper/stats_funs.R")

instruments <- read_feather("data/_common/instruments.feather")
admins <- read_feather("data/_common/admins.feather")
items <- read_feather("data/_common/items.feather")

# instruments <- get_instruments()
# write_feather(instruments, "data/_common/instruments.feather")
# admins <- get_administration_data(original_ids = TRUE)
# write_feather(admins, "data/_common/admins.feather")
# items <- get_item_data()
# write_feather(items, "data/_common/items.feather")


### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")
