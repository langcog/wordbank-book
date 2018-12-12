fs <- list.files(pattern = "*.Rmd")

bibs <- read_file("book.bib") %>% str_match_all("@.*\\{(.*),") %>%
  .[[1]] %>% .[,2]

get_cites <- function(f) {
  read_file(f) %>% str_extract_all("@[a-z0-9-]+") %>%
    .[[1]] %>% str_sub(2, str_length(.)) %>% discard(~str_detect(.x, "ref"))
}

fs %>% map(~.x %>% get_cites %>% setdiff(bibs)) %>%
  set_names(fs) %>%
  compact()
