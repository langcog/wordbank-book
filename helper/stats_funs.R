ci.t <- function(x) {
  n = sum(is.finite(x))
  qt(0.975, df = n - 1) * sd(x, na.rm = TRUE)/sqrt(n)
}

## FIXME! these have no error checking
mmad <- function(x) median(x) / mad(x)
madm <- function(x) mad(x) / median(x)
d <- function(x) mean(x) / sd(x)
cv <- function(x) abs(sd(x, na.rm=TRUE) / mean(x, na.rm=TRUE))
cv_sem <- function(x) cv(x) / sqrt(2 * sum(!is.na(x))) # http://influentialpoints.com/Training/standard_error_of_coefficient_of_variation.htm
