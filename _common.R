library(wordbankr)
library(langcog)
library(knitr)
library(feather)
library(tidyverse)
library(glue)
library(kableExtra)

opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  error = FALSE,
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  echo = FALSE,
  cache.lazy = FALSE,
  fig.align = "left",
  fig.show = "hold",
  dev = "png",
  dpi = 300,
  out.width = "\\linewidth"
)

set.seed(42)

.font <- "Source Sans Pro"
.uni_font <- "Gulim"
theme_set(theme_mikabr(base_family = .font))
theme_update(plot.margin = margin(0, 0, 2, 0, "pt"),
             legend.margin = margin(0, 0, 0, 0, "pt"))
.grey <- "grey70"
.refline <- "dotted"
.coef_line <- element_line(colour = .grey, size = 0.1)

.ages <- seq(5, 45, 5)

.pal <- ggthemes::ptol_pal

.scale_colour_discrete <- ggthemes::scale_colour_ptol
.scale_color_discrete <- .scale_colour_discrete
.scale_fill_discrete <- ggthemes::scale_fill_ptol

.scale_colour_continuous <- viridis::scale_colour_viridis
.scale_color_continuous <- .scale_colour_continuous
.scale_fill_continuous <- viridis::scale_fill_viridis

.scale_colour_numerous <- scale_colour_discrete
.scale_color_numerous <- .scale_colour_numerous
.scale_fill_numerous <- scale_fill_discrete

source("helper/predictQR.R")
source("helper/stats_funs.R")

# instruments <- get_instruments()
# write_feather(instruments, "data/_common/instruments.feather")
# admins <- get_administration_data(original_ids = TRUE)
# write_feather(admins, "data/_common/admins.feather")
# items <- get_item_data()
# write_feather(items, "data/_common/items.feather")

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
lang_colours["French (Québécois)"] <- lang_colours["French (Quebecois)"]

insts <- instruments %>%
  select(language, form) %>%
  unite(instrument, language, form, sep = .inst_sep, remove = FALSE) %>%
  left_join(langs)
inst_colours <- insts$colour %>% set_names(insts$instrument)
inst_colours["French (Québécois) WG"] <- inst_colours["French (Quebecois) WG"]
inst_colours["French (Québécois) WS"] <- inst_colours["French (Quebecois) WS"]

### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")

# round and print trailing zeroes
roundp <- function(x, digits = 2) {
  sprintf(glue('%.{digits}f'), round(x, digits)) %>% str_replace("-", "–")
}

print_pvalue <- function(x, min_val = 0.001) {
  if (x < min_val) glue("< {min_val}") else glue("= {roundp(x)}")
}

label_caps <- as_labeller(function(value) {
  paste0(toupper(substr(value, 1, 1)), substr(value, 2, nchar(value))) %>%
    str_replace_all("_", " ")
})

kable <- function(...) knitr::kable(..., booktabs = TRUE, linesep = "")

