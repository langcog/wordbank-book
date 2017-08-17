library(wordbankr)
library(langcog)
library(tidyverse)
library(directlabels)
library(forcats)
library(DT)
library(quantregGrowth)
library(stringr)
library(feather)
library(ggrepel)

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
  write_feather(instruments, "data/instruments.feather")
  admins <- get_administration_data()
  write_feather(admins, "data/admins.feather")
  items <- get_item_data()
  write_feather(items, "data/items.feather")

}


## functions
ci.t <- function (x) {
  n = sum(is.finite(x))
  qt(0.975, df=n - 1) * sd(x, na.rm=TRUE)/sqrt(n)
}
