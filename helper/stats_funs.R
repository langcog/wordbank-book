ci.t <- function(x) {
  n = sum(is.finite(x))
  qt(0.975, df = n - 1) * sd(x, na.rm = TRUE)/sqrt(n)
}

## FIXME! these have no error checking
mmad <- function(x) median(x) / mad(x)
madm <- function(x) mad(x) / median(x)
d <- function(x) mean(x) / sd(x)
cv <- function(x) sd(x) / mean(x)
