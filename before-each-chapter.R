rm(list=ls(all=TRUE))

set.seed(1967)

# Copy some Hadley code from r4ds
options(digits = 3)
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  echo = TRUE,
  cache = TRUE,
  out.width = "70%",
  fig.align = 'center',
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold"
)

# Everything depends on fpp2
library(fpp2, quietly=TRUE)

