library(tidyverse)
library(glue)

fs <- list.files(pattern = "*.Rmd")
fs_content <- map_chr(fs, read_file) %>% paste(collapse = "")

figs <- list.files("docs/wordbank-book_files/figure-html") %>%
  str_remove("\\.png") %>%
  str_remove("-[1-9]")

fig_caps <- figs %>%
  map_chr(~fs_content %>%
            str_extract(sprintf("```\\{r %s.*\\}", .x)) %>%
            str_match('fig.cap="(.*)"') %>% .[,2]) %>%
  as_tibble() %>%
  mutate(figure = figs,
         chapter = figure %>% str_match("(.*?)-") %>% .[,2]) %>%
  select(chapter, figure, caption = value)

fig_caps %>%
  filter(is.na(caption))
