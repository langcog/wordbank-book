## Variability and Consistency in Early Language Learning: The Wordbank Project
### Michael Frank, Mika Braginsky, Virginia Marchman, and Daniel Yurovsky

An examination of early language development across languages, using parent reports through the MacArthur-Bates Communicative Development Inventory and its adaptations.

Visible at: https://langcog.github.io/wordbank-book/index.html

Still under active development, in early and incomplete draft form. Manuscript due to MIT Press in Summer 2018.


---

## Building the book

- Install R, RStudio, and a LaTeX distribution (e.g. [MacTeX](http://www.tug.org/mactex/)).

- Clone this repository.

- Open the project `wordbank-book.proj` in RStudio.

- Install all R packages listed under `Imports` in the `DESCRIPTION` file using `install.packages()`.

- Install all R packages listed under `Remotes` in the `DESCRIPTION` file using `devtools::install_packages()`.

- Add the fonts in the `fonts/` directory to your system (e.g. copy them to Font Book on OSX).

- Run `extrafont::font_import("fonts")` and then `extrafont::loadfonts()`.

- Under the RStudio `Build` menu click on `Build Book` (select `bookdown::gitbook` to build only the html version or `bookdown::pdf_book` to build only the pdf version).
