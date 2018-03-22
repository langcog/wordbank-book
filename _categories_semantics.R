###### Scripts to support categories_semantics chapter #######

## DATA LOADING PLUS CATEGORY-FINDING

get_cat_comp <- function(input_language, input_form) {
  print(paste(input_language,input_form))

  lang_vocab_items <- filter(items,
                             language == input_language,
                             form == input_form) %>%
    filter(category %in% category_freqs$category)

  lang_vocab_data <- get_instrument_data(language = input_language,
                                         form = input_form,
                                         items = lang_vocab_items$item_id,
                                         iteminfo = lang_vocab_items) %>%
    mutate(value = ifelse(is.na(value), "", value),
           produces = value == "produces",
           understands = value == "produces" | value == "understands") %>%
    dplyr::select(-value) %>%
    gather(measure, value, produces, understands)

  num_words <- nrow(lang_vocab_items)

  lang_vocab_summary <- lang_vocab_data %>%
    group_by(data_id, measure, category) %>%
    summarise(num_true = sum(value),
              prop = sum(value) / n())

  lang_vocab_sizes <- lang_vocab_summary %>%
    summarise(vocab_num = sum(num_true),
              vocab = sum(num_true) / num_words)

  lang_vocab_summary %>%
    left_join(lang_vocab_sizes) %>%
    mutate(prop_vocab = num_true / vocab_num) %>%
    dplyr::select(-num_true) %>%
    mutate(language = input_language, form = input_form)
}

included_instruments <- instruments %>%
  filter(form %in% WSs) %>%
  select(language, form) %>%
  distinct()

cat_comp_data <- map2(included_instruments$language,
                      included_instruments$form, get_cat_comp) %>%
  bind_rows()

write_feather(cat_comp_data, "data/cat_comp_data.feather")

## RESAMPLING AND CACHING CODE

sample_areas <- function(d, nboot = 1000) {

  poly_area <- function(group_data) {
    model = clm(prop ~ I(vocab ^ 3) + I(vocab ^ 2) + vocab - 1,
                data = group_data)
    return((model$solution %*% c(1/4, 1/3, 1/2) - 0.5)[1])
  }

  counter <- 1
  sample_area <- function(d) {
    d_frame <- d %>%
      group_by(language, form, measure) %>%
      sample_frac(replace = TRUE) %>%
      group_by(language, form, measure, category) %>%
      do(area = poly_area(.)) %>%
      mutate(area = area[1]) %>%
      rename_(.dots = setNames("area", counter))

    counter <<- counter + 1 # increment counter outside scope
    return(d_frame)
  }

  areas <- replicate(nboot, sample_area(d), simplify = FALSE)

  Reduce(left_join, areas) %>%
    gather(sample, area, -language, -form, -measure, -category)
}

areas <- sample_areas(cat_comp_data, nboot=100)
write_feather(areas,"data/sem_vocab_comp_areas.feather")


