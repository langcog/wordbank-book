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

knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  fig.align = "center",
  fig.show = "hold"
)

ggplot2::theme_set(langcog::theme_mikabr())
font <- langcog::theme_mikabr()$text$family
