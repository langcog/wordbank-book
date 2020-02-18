library(tidyverse)

fs <- list.files(pattern = "*.Rmd")

get_key <- function(f) {
  read_file(f) %>% str_match("\\{#(.*?)\\}") %>% .[,2]
}

keys <- fs %>% map_chr(get_key) %>% discard(is.na)

get_refs <- function(f) {
  read_file(f) %>% str_match_all("\\@ref\\((.*?)\\)") %>% .[[1]] %>% .[,2] %>%
    discard(~str_detect(.x, "fig:") | str_detect(.x, "tab:"))
}

fs %>% map(~.x %>% get_refs %>% setdiff(keys)) %>%
  set_names(fs) %>%
  compact()
