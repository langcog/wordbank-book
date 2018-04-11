library(wordbankr)
library(langcog)
library(directlabels)
library(forcats)
library(DT)
library(quantregGrowth)
library(feather)
library(ggrepel)
library(ggdendro) # ch5
library(rms)
library(metafor)
library(broom)
library(gridExtra)
library(modelr) # ch 7b
library(binom) # ch2
library(lme4)
library(ggfortify)
library(tidyverse) # keep tidyverse last to prevent conflicts
library(rlang)
select <- dplyr::select
summarise <- dplyr::summarise
# library(robustbase) # appendix-aoa
# library(arm) # appendix-aoa
# library(rstan) # appendix-aoa


knitr::opts_chunk$set(
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
  admins <- get_administration_data(original_ids = TRUE)
  write_feather(admins, "data/admins.feather")
  items <- get_item_data()
  write_feather(items, "data/items.feather")

  # cleanup of non-WS/WG instruments

}


## functions
ci.t <- function (x) {
  n = sum(is.finite(x))
  qt(0.975, df=n - 1) * sd(x, na.rm=TRUE)/sqrt(n)
}

## FIXME! these have no error checking
mmad <- function(x) {median(x) / mad(x) }
madm <- function(x) {mad(x) / median(x) }
d <- function(x) {mean(x) / sd(x) }
cv <- function(x) {sd(x) / mean(x) }


## GCRQ-related functions for 3 and 3b

fit_gcrq <- function(x) {
  mod <- try(gcrq(formula = mean ~ ps(age, monotone = 1,
                                      lambda = 1000),
                  tau = taus, data = x))

  if(inherits(mod, "try-error"))
  {
    return(NA)
  }

  return(mod)
}

pred_gcrq <- function(x, mods) {
  mod <- mods[[x$language[1]]]

  if (is.na(mod[1])) {
    return(expand.grid(age = x$age,
                       language = x$language[1],
                       percentile = as.character(taus*100),
                       pred = NA))
  } else {
    preds <- predictQR_fixed(mod,
                             newdata = x) %>%
      data.frame %>%
      mutate(age = x$age,
             language = x$language) %>%
      gather(percentile, pred, starts_with("X")) %>%
      mutate(percentile = as.character(as.numeric(str_replace(percentile,
                                                              "X", ""))
                                       * 100))
    return(preds)
  }
}

### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")

