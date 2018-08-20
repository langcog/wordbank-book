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
library(langcog)
library(tidyverse) # keep tidyverse last to prevent conflicts


# to deal with font issue perhaps?
# library(extrafont)
# loadfonts()

library(robustbase) # appendix-aoa
library(arm) # appendix-aoa
library(rstan) # appendix-aoa


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

theme_set(theme_mikabr())
.font <- theme_mikabr()$text$family
