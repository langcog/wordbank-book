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

.pal <- ggthemes::ptol_pal
.scale_colour_discrete <- ggthemes::scale_colour_ptol
.scale_fill_discrete <- ggthemes::scale_fill_ptol
.scale_colour_continuous <- viridis::scale_colour_viridis
.scale_fill_continuous <- viridis::scale_fill_viridis
.scale_colour_numerous <- scale_colour_discrete
.scale_fill_numerous <- scale_fill_discrete

source("helper/predictQR.R")
source("helper/stats_funs.R")

instruments <- read_feather("data/_common/instruments.feather")
admins <- read_feather("data/_common/admins.feather")
items <- read_feather("data/_common/items.feather")

.inst_sep = " "
pal <- scales::hue_pal(h = c(0, 360) + 15, c = 100, l = 65, h.start = 0,
                       direction = 1)

langs <- instruments %>%
  select(language) %>%
  distinct() %>%
  arrange(language) %>%
  mutate(colour = pal(n()))
lang_colours <- langs$colour %>% set_names(langs$language)

insts <- instruments %>%
  select(language, form) %>%
  unite(instrument, language, form, sep = .inst_sep, remove = FALSE) %>%
  left_join(langs)
inst_colours <- insts$colour %>% set_names(insts$instrument)

# instruments <- get_instruments()
# write_feather(instruments, "data/_common/instruments.feather")
# admins <- get_administration_data(original_ids = TRUE)
# write_feather(admins, "data/_common/admins.feather")
# items <- get_item_data()
# write_feather(items, "data/_common/items.feather")


### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")
