rm(list = ls())

library(wordbankr)
library(langcog)
library(knitr)
library(feather)
library(tidyverse)

# extrafont::loadfonts()

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
