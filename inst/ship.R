# render book to pdf
rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')

# reset shipping directory
shipit <- "inst/wordbank-book_build"
unlink(shipit, recursive = TRUE)
dir.create(shipit)

# copy over tex, bib, cls, and fonts
files <- c("docs/wordbank-book.tex",
           "wordbank-book.bib",
           "newmath.cls")
purrr::walk(files, purrr::partial(file.copy, to = shipit, recursive = TRUE))

# copy over fonts
file.copy("fonts", shipit, recursive = TRUE)

# copy over images
dir.create(file.path(shipit, "images"))
file.copy(list.files("images", "*.png", full.names = TRUE), file.path(shipit, "images"))

# copy over figures
dir.create(file.path(shipit, "wordbank-book_files"))
file.copy("_bookdown_files/wordbank-book_files/figure-latex",
          file.path(shipit, "wordbank-book_files"), recursive = TRUE)

# run lualatex, then bibtex, then lualatex again twice
setwd(file.path(getwd(), shipit))
system("lualatex wordbank-book.tex")
system("bibtex wordbank-book.aux")
system("lualatex wordbank-book.tex")
system("lualatex wordbank-book.tex")

# delete latex side effect files
unlink(list.files(pattern = ".*aux|blg|idx|log|out|toc"))

# rename pdf to include date
file.rename("wordbank-book.pdf",
            glue::glue("wordbank-book_{lubridate::today()}.pdf"))
