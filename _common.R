library(wordbankr)
library(langcog)
library(knitr)
library(feather)
library(tidyverse)

# extrafont::loadfonts()

options(digits = 2,
        DT.options = list(searching = FALSE,
                          lengthChange = FALSE,
                          columnDefs = list(list(
                            className = "dt-head-left", targets = "_all"
                          ))))
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

.font <- "Source Sans Pro"
theme_set(theme_mikabr(base_family = .font))
theme_update(plot.margin = margin(0, 0, 2, 0, "pt"),
             legend.margin = margin(0, 0, 0, 0, "pt"))
.grey <- "grey70"
.refline <- "dotted"
.ages <- seq(5, 45, 5)

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

printp <- function(x, min_val = 0.001) {
  if (x < min_val) sprintf("< %s", min_val) else sprintf("%.3f", x)
}

label_caps <- as_labeller(function(value) {
  paste0(toupper(substr(value, 1, 1)), substr(value, 2, nchar(value))) %>%
    str_replace_all("_", " ")
})

dt_caption <- function(caption) {
  glue::glue('<table> <caption> (#tab:{opts_current$get("label")}) {caption} </caption> </table>')
}

dt <- function(data, ...) {
  DT::datatable(
    data = data,
    rownames = FALSE,
    colnames = label_caps(colnames(data)),
    ...
  )
}
