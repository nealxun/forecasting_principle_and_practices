rm(list=ls(all=TRUE))

set.seed(1967)

options(digits = 3)
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  echo = TRUE,
  cache = TRUE,
  out.width = "90%",
  fig.align = 'center',
  fig.width = 7,
  fig.asp = 0.618  # 1 / phi
)

library(fpp2, quietly=TRUE)

