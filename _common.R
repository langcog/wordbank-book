library(wordbankr)
library(langcog)
library(tidyverse)
library(ggplot2)
library(directlabels)
library(forcats)
library(purrr)
library(DT)
library(quantregGrowth)
library(stringr)
library(feather)

knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  echo = FALSE,
  fig.align = "center",
  fig.show = "hold"
)

ggplot2::theme_set(langcog::theme_mikabr())
font <- langcog::theme_mikabr()$text$family
source("helper/predictQR_fixed.R")

local_data <- TRUE

if (local_data) {
  instruments <- read_feather("data/instruments.feather")
  admins <- read_feather("data/admins.feather")
  items <- read_feather("data/items.feather")
} else {
  instruments <- get_instruments()
  admins <- get_administration_data()
  items <- get_item_data()

}
