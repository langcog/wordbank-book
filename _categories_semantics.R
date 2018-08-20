###### Scripts to support categories_semantics chapter #######

## DATA LOADING PLUS CATEGORY-FINDING --------------------------

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
    select(-value) %>%
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
    select(-num_true) %>%
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

## RESAMPLING AND CACHING CODE  --------------------------

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

## SEMANTIC CATEGORY CACHING  --------------------------
get_unilemma_trajectories <- function(target_category = NA,
                                      uni_lemmas = NA,
                                      threshold = 10) {

  if (!is.na(target_category)) {

    category_items <- items %>%
      filter(category == target_category,
             !is.na(uni_lemma),
             form %in% WSs)
  } else {
    category_items <- items %>%
      filter(!is.na(uni_lemma),
             uni_lemma %in% uni_lemmas,
             form %in% WSs)
  }

  # include with more than N unilemma languages
  included_words <- category_items %>%
    group_by(uni_lemma) %>%
    summarise(n=n()) %>%
    filter(n > threshold) %>%
    pull(uni_lemma)

  # filter
  all_cat_items <- category_items %>%
    filter(uni_lemma %in% included_words)

  # get admins for each language and summarise immediately (for space/processing)
  all_cat_items %>%
    mutate(langform = paste(language, form, sep = " ")) %>%
    split(.$langform) %>%
    map_df(function (cat_items) {
      print(cat_items$language[1])

      get_instrument_data(language = cat_items$language[1],
                          form = cat_items$form[1],
                          items = cat_items$item_id,
                          administrations = TRUE) %>%
        mutate(produces = ifelse(is.na(value), FALSE, value == "produces")) %>%
        select(num_item_id, age, produces) %>%
        left_join(cat_items %>%
                    select(num_item_id, definition, language, form, uni_lemma)) %>%
        group_by(uni_lemma, age, language, form) %>%
        summarise(ci_lower = binom.confint(x = sum(produces), n = n(),
                                           method = "bayes")$lower,
                  ci_upper = binom.confint(x = sum(produces), n = n(),
                                           method = "bayes")$upper,
                  mean = mean(produces),
                  n = n())

    })
}

# cache various
# time, color, body parts, logic, number
time_words <- get_unilemma_trajectories(target_category = "time_words")
write_feather(time_words, "data/time_words.feather")


body_words <- get_unilemma_trajectories(uni_lemmas = c("arm", "leg", "hand",
                                                       "foot", "finger", "toe") )
write_feather(body_words, "data/body_words.feather")


color_words <- get_unilemma_trajectories(uni_lemmas = c("red","blue","green",
                                                        "yellow","purple","pink",
                                                        "orange","brown","gray",
                                                        "black","white"),
                                         threshold = 5)
write_feather(color_words, "data/color_words.feather")


logic_words <- get_unilemma_trajectories(uni_lemmas = c("no", "some", "all",
                                                        "none","and","or",
                                                        "not","because",
                                                        "then","if"),
                                         threshold = 5)
write_feather(logic_words, "data/logic_words.feather")

# not enoguh number, hard to map space.

# control group
animal_words <- get_unilemma_trajectories(target_category = "animals")
write_feather(animal_words, "data/animal_words.feather")



