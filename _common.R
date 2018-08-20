rm(list = ls())

source("helper/predictQR.R")
source("helper/stats_funs.R")

local_data <- TRUE

if (local_data) {
  instruments <- feather::read_feather("data/instruments.feather")
  admins <- feather::read_feather("data/admins.feather")
  items <- feather::read_feather("data/items.feather")
} else {
  instruments <- wordbankr::get_instruments()
  feather::write_feather(instruments, "data/instruments.feather")
  admins <- wordbankr::get_administration_data(original_ids = TRUE)
  feather::write_feather(admins, "data/admins.feather")
  items <- wordbankr::get_item_data()
  feather::write_feather(items, "data/items.feather")
}


### FORM VARIANTS
WGs <- c("WG", "IC", "Oxford CDI")
WSs <- c("WS", "TC")
