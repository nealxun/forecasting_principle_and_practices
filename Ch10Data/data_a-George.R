setwd("C:/Users/tomas/Dropbox/Forecasting Prison Numbers/Data")
setwd("C:/Users/steelto/Dropbox/Forecasting Prison Numbers/Data")
#setwd("C:/Users/steelto/Documents")

library(data.table)
library(stringi)
library(stringr)
library(recoder)
library(forcats)
library(doBy)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(scales)
library(lubridate)
library(gridExtra)
library(ggplot2)


forecast.gts2 <- function (object, h = ifelse(frequency(object$bts) > 1L, 2L *
                          frequency(object$bts), 10L), method = c("comb", "bu", "mo", "tdgsa", "tdgsf", "tdfp"),
                          weights = c("wls", "ols", "mint","nseries"),
                          fmethod = c("ets", "arima", "rw"),
                          algorithms = c("lu","cg", "chol", "recursive", "slm"),
                          covariance = c("shr", "sam"),
                          keep.fitted = FALSE, keep.resid = FALSE, positive = FALSE,
                          lambda = NULL, level, parallel = FALSE, num.cores = 2, FUN = NULL,
                          xreg = NULL, newxreg = NULL, ...)
{
  method <- match.arg(method)
  if (length(weights) == 1L) {
    if (weights == "sd")
      weights <- "wls"
    else if (weights == "none")
      weights <- "ols"
  }
  weights <- match.arg(weights)
  covariance <- match.arg(covariance)
  alg <- match.arg(algorithms)
  if (is.null(FUN)) {
    fmethod <- match.arg(fmethod)
  }
  if (!hts:::is.gts(object)) {
    stop("Argument object must be either a hts or gts object.")
  }
  if (h < 1L) {
    stop("Argument h must be positive.")
  }
  if (!hts:::is.hts(object) && is.element(method, c("mo", "tdgsf",
                                                    "tdgsa", "tdfp"))) {
    stop("Argument method is not appropriate for a non-hierarchical time series.")
  }
  if (method == "mo" && missing(level)) {
    stop("Please specify argument level for the middle-out method.")
  }
  if (is.null(lambda)) {
    if (positive) {
      if (any(object$bts <= 0L, na.rm = FALSE)) {
        stop("All data must be positive.")
      }
      else {
        lambda <- 0
      }
    }
    else {
      lambda <- NULL
    }
  }
  keep.fitted0 <- keep.fitted
  if (method == "comb" && (weights == "mint" || weights ==
                           "wls")) {
    keep.fitted <- TRUE
  }
  if (method == "mo") {
    len <- length(object$nodes)
    if (level < 0L || level > len) {
      stop("Argument level is out of the range.")
    }
    else if (level == 0L) {
      method <- "tdfp"
    }
    else if (level == len) {
      method <- "bu"
    }
    else {
      mo.nodes <- object$nodes[level:len]
      level <- seq(level, len)
    }
  }
  if (any(method == c("comb", "tdfp"))) {
    y <- aggts(object)
  }
  else if (method == "bu") {
    y <- object$bts
  }
  else if (any(method == c("tdgsa", "tdgsf")) && method !=
           "tdfp") {
    y <- aggts(object, levels = 0)
  }
  else if (method == "mo") {
    y <- aggts(object, levels = level)
  }
  loopfn <- function(x, ...) {
    out <- list()
    if (is.null(FUN)) {
      if (fmethod == "ets") {
        models <- ets(x, lambda = lambda, ...)
        out$pfcasts <- forecast(models, h = h, PI = FALSE)$mean
      }
      else if (fmethod == "arima") {
        models <- auto.arima(x, lambda = lambda, xreg = xreg,
                             parallel = FALSE, ...)
        out$pfcasts <- forecast(models, h = h, xreg = newxreg)$mean
      }
      else if (fmethod == "rw") {
        models <- rwf(x, h = h, lambda = lambda, ...)
        out$pfcasts <- models$mean
      }
    }
    else {
      models <- FUN(x, ...)
      out$pfcasts <- forecast(models, h = h)$mean
    }
    if (keep.fitted) {
      out$fitted <- stats::fitted(models)
    }
    if (keep.resid) {
      out$resid <- stats::residuals(models)
    }
    return(out)
  }
  if (parallel) {
    if (is.null(num.cores)) {
      num.cores <- detectCores()
    }
    lambda <- lambda
    xreg <- xreg
    newxreg <- newxreg
    cl <- makeCluster(num.cores)
    loopout <- parSapplyLB(cl = cl, X = y, FUN = function(x) loopfn(x,
                                                                    ...), simplify = FALSE)
    stopCluster(cl = cl)
  }
  else {
    loopout <- lapply(y, function(x) loopfn(x, ...))
  }
  pfcasts <- pfcasts0 <- sapply(loopout, function(x) x$pfcasts)
  if (keep.fitted) {
    fits <- sapply(loopout, function(x) x$fitted)
  }
  if (keep.resid) {
    resid <- sapply(loopout, function(x) x$resid)
  }
  if (is.vector(pfcasts)) {
    pfcasts <- t(pfcasts)
  }
  tsp.y <- stats::tsp(y)
  bnames <- colnames(object$bts)
  if (method == "comb") {
    class(pfcasts) <- class(object)
    if (keep.fitted) {
      class(fits) <- class(object)
    }
    if (keep.resid) {
      class(resid) <- class(object)
    }
    if (weights == "nseries") {
      if (hts:::is.hts(object)) {
        wvec <- InvS4h(object$nodes)
      }
      else {
        wvec <- InvS4g(object$groups)
      }
    }
    else if (weights == "wls") {
      tmp.resid <- y - fits
      wvec <- 1/sqrt(colMeans(tmp.resid^2, na.rm = TRUE))
    }
    else if (weights == "mint") {
      tmp.resid <- stats::na.omit(y - fits)
    }
  }
  Comb <- function(x, ...) {
    if (hts:::is.hts(x)) {
      return(combinef(x, nodes = object$nodes, ...))
    }
    else {
      return(combinef(x, groups = object$groups, ...))
    }
  }
  mint <- function(x, ...) {
    if (hts:::is.hts(x)) {
      return(MinT(x, nodes = object$nodes, ...))
    }
    else {
      return(MinT(x, groups = object$groups, ...))
    }
  }
  if (method == "comb") {
    if (weights == "ols") {
      bfcasts <- Comb(pfcasts, keep = "bottom", algorithms = alg)
    }
    else if (any(weights == c("wls", "nseries"))) {
      bfcasts <- Comb(pfcasts, weights = wvec, keep = "bottom",
                      algorithms = alg)
    }
    else {
      bfcasts <- mint(pfcasts, residual = tmp.resid, covariance = covariance,
                      keep = "bottom", algorithms = alg)
    }
    if (keep.fitted0) {
      if (weights == "ols") {
        fits <- Comb(fits, keep = "bottom", algorithms = alg)
      }
      else if (any(weights == c("wls", "nseries"))) {
        fits <- Comb(fits, weights = wvec, keep = "bottom",
                     algorithms = alg)
      }
      else if (weights == "mint") {
        fits <- mint(fits, residual = tmp.resid, covariance = covariance,
                     keep = "bottom", algorithms = alg)
      }
    }
    if (keep.resid) {
      if (weights == "ols") {
        resid <- Comb(resid, keep = "bottom", algorithms = alg)
      }
      else if (any(weights == c("wls", "nseries"))) {
        resid <- Comb(resid, weights = wvec, keep = "bottom",
                      algorithms = alg)
      }
      else if (weights == "mint") {
        resid <- mint(resid, residual = tmp.resid, covariance = covariance,
                      keep = "bottom", algorithms = alg)
      }
    }
  }
  else if (method == "bu") {
    bfcasts <- pfcasts
  }
  else if (method == "tdgsa") {
    bfcasts <- TdGsA(pfcasts, object$bts, y)
    if (keep.fitted0) {
      fits <- TdGsA(fits, object$bts, y)
    }
    if (keep.resid) {
      resid <- TdGsA(resid, object$bts, y)
    }
  }
  else if (method == "tdgsf") {
    bfcasts <- TdGsF(pfcasts, object$bts, y)
    if (keep.fitted0) {
      fits <- TdGsF(fits, object$bts, y)
    }
    if (keep.resid) {
      resid <- TdGsF(resid, object$bts, y)
    }
  }
  else if (method == "tdfp") {
    bfcasts <- TdFp(pfcasts, object$nodes)
    if (keep.fitted0) {
      fits <- TdFp(fits, object$nodes)
    }
    if (keep.resid) {
      resid <- TdFp(resid, object$nodes)
    }
  }
  else if (method == "mo") {
    bfcasts <- MiddleOut(pfcasts, mo.nodes)
    if (keep.fitted0) {
      fits <- MiddleOut(fits, mo.nodes)
    }
    if (keep.resid) {
      resid <- MiddleOut(resid, mo.nodes)
    }
  }
  if (method == "comb" && fmethod == "rw" && keep.fitted0 ==
      TRUE && (alg == "slm" || alg == "chol")) {
    fits <- rbind(rep(NA, ncol(fits)), fits)
  }
  bfcasts <- ts(bfcasts, start = tsp.y[2L] + 1L/tsp.y[3L],
                frequency = tsp.y[3L])
  colnames(bfcasts) <- bnames
  class(bfcasts) <- class(object$bts)
  attr(bfcasts, "msts") <- attr(object$bts, "msts")
  if (keep.fitted0) {
    bfits <- ts(fits, start = tsp.y[1L], frequency = tsp.y[3L])
    colnames(bfits) <- bnames
  }
  if (keep.resid) {
    bresid <- ts(resid, start = tsp.y[1L], frequency = tsp.y[3L])
    colnames(bresid) <- bnames
  }
  out <- list(bts = bfcasts, histy = object$bts, labels = object$labels,
              method = method, fmethod = fmethod)
  if (keep.fitted0) {
    out$fitted <- bfits
  }
  if (keep.resid) {
    out$residuals <- bresid
  }
  if (hts:::is.hts(object)) {
    out$nodes <- object$nodes
  }
  else {
    out$groups <- object$groups
  }
  return(list(structure(out, class = class(object)), pfcasts0))
}



#clean the dataset
library(data.table)

dfa <- read.csv("prison.csv", strip.white = TRUE)

dfa$indigenous[dfa$indigenous =="3"] <- "2"
dfa$indigenous <- as.character(dfa$indigenous)

dfa$legal[dfa$legal =="2"] <- "1"
dfa$legal <- as.character(dfa$legal)

dfa$legal[dfa$legal =="3"] <- "2"
dfa$legal <- as.character(dfa$legal)

dfa$legal[dfa$legal =="4"] <- "2"
dfa$legal <- as.character(dfa$legal)


dfa$count <- as.numeric(dfa$count)

dfa <- aggregate(count ~ state + sex + legal + indigenous + date, data = dfa, FUN = sum)

dfa_w <- reshape(dfa, idvar = c("state", "sex", "legal", "indigenous"), timevar = "date", direction = "wide")

dfa_w$pathString <- paste(dfa_w$state,#length=1
                          dfa_w$sex, #length=1
                          dfa_w$legal, #length=1
                          dfa_w$indigenous,#length=1
                          sep="")

#rename the columns
setnames(dfa_w, old=c("count.2005/03/01","count.2005/06/01","count.2005/09/01","count.2005/12/01", "count.2006/03/01", "count.2006/06/01", "count.2006/09/01", "count.2006/12/01", "count.2007/03/01", "count.2007/06/01", "count.2007/09/01", "count.2007/12/01", "count.2008/03/01", "count.2008/06/01", "count.2008/09/01", "count.2008/12/01", "count.2009/03/01", "count.2009/06/01", "count.2009/09/01", "count.2009/12/01", "count.2010/03/01", "count.2010/06/01", "count.2010/09/01", "count.2010/12/01", "count.2011/03/01", "count.2011/06/01", "count.2011/09/01", "count.2011/12/01", "count.2012/03/01","count.2012/06/01","count.2012/09/01","count.2012/12/01", "count.2013/03/01", "count.2013/06/01", "count.2013/09/01", "count.2013/12/01", "count.2014/03/01", "count.2014/06/01", "count.2014/09/01", "count.2014/12/01", "count.2015/03/01", "count.2015/06/01", "count.2015/09/01", "count.2015/12/01", "count.2016/03/01","count.2016/06/01","count.2016/09/01","count.2016/12/01"),
         new=c("2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01"))

myvars <- c("pathString","2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01")
newdata <- dfa_w[myvars]

#transpose the data
newdata2 <- t(newdata)

#rename the columns and remove the first row
colnames(newdata2) = newdata2[1,]
newdata2 = newdata2[-1,]

newdata2[newdata2 == 'n/a'] = NA
newdata2 = apply(newdata2, 2, as.numeric)

library(hts)
bts <- ts(newdata2, start=c(2005,1), end=c(2016,4), frequency=4)

#nchar(newdata$pathString) #4
#ncol(bts)

#y.gts <- gts(bts, characters = c(1,1,1,1))
#allts(y.gts)[,2]

# 8 states, 2 sex, 2 gender, 2 indigenous
state <- rep(c("NSW", "VIC", "QLD", "SA", "WA", "NT", "ACT", "TAS"), 64/8)
sex <- rep(rep(c("m","f"),each=8),4)
ind <- rep(rep(c("I","NI"),each=16),2)
leg <- rep(c("s","r"),each=64/2)

state_sex <- as.character(interaction(state,sex,sep=""))
state_leg <- as.character(interaction(state,leg, sep=""))
state_ind <- as.character(interaction(state,ind, sep=""))
sex_leg <- as.character(interaction(sex,leg, sep=""))
sex_ind <- as.character(interaction(sex,ind,sep=""))
ind_leg <- as.character(interaction(ind,leg, sep=""))

state_sex_leg <- as.character(interaction(state,sex,leg,sep=""))
state_sex_ind <- as.character(interaction(state,sex,ind,sep=""))
state_leg_ind <- as.character(interaction(state,leg,ind,sep=""))

sex_leg_ind <- as.character(interaction(sex,leg,ind,sep=""))


#state_sex_ind <- as.character(interaction(state,sex,ind, sep=""))

gc <-rbind(state,sex,ind,leg, state_sex, state_ind, state_leg, sex_ind,
           sex_leg, ind_leg, state_sex_leg, state_sex_ind, state_leg_ind, 
           sex_leg_ind)

y <- gts(bts,groups=gc)

ncol(allts(y))
#get_groups(y)

# tmp = forecast.gts2(y, h = 8, method = "comb", weights = "wls", fmethod = "ets")
# allts(tmp[[1]])[,1]
# tmp[[2]][,1]


ally <- allts(y)
nc <- ncol(ally) # Number of series
nr <- nrow(ally) # Number of observations for each series
h <- 8L
nfreq <- 4L
time.attr <- tsp(y.gts$bts)

train.size <- 40L  # Number of observations for training
n.iter <- nr - train.size  # Total number of iterations
test.size <- nr - train.size # The available obs for testing

fcasts.base <- array(, dim=c(n.iter, h, nc))
fcasts.opt <- array(, dim=c(n.iter, h, nc))
test.y <- array(, dim=c(n.iter, h, nc))

fcasts.base[,,240]

#j=1
for (j in 1:test.size) {
  starting <- time.attr[1L] + (j - 1L)/nfreq
  ending <- time.attr[1L] + (train.size + j - 2L)/nfreq

  # Start rolling forecast window
  train.gts <- gts(window(y$bts, start = starting, end = ending), groups = gc)
  test.gts <- gts(window(y$bts, start = ending + 1/nfreq), groups = gc)

  # Fitting ARIMA or ETS models
  fcasts.gts <- forecast.gts2(train.gts, h=h, method = "comb", weights = "wls", fmethod = "ets")
  
  fcasts.opt[j, , ] <- allts(fcasts.gts[[1]])  
  fcasts.base[j, , ] <- fcasts.gts[[2]]
  test.y[j,j:h , ] <- allts(test.gts) # we only need this once so a bit of a fudge here
print(j)
}


# The indices below are not correct - I am just introducing the 
# accuracy command for both two ts objects but also two vectors.
# You need to think here on how you will exctract the error measures
# for h=1 to 4 steps ahead over the rolling window. The errors 

allts(fcasts.gts[[1]])[,1]
fcasts.gts[[2]][,1]
allts(test.gts)[,1]

accuracy(allts(fcasts.gts[[1]])[,j],allts(test.gts)[,1])
accuracy(fcasts.gts[[2]][,j],as.vector(allts(test.gts)[,1]))



all_recon1 <- as.data.frame(allts(fcasts.gts[[1]])[,1]) #this is the reconciled fcasts for level 1
all_recon2 <- as.data.frame((fcasts.gts[[2]])[,1]) #these are the base forecasts for level 1

all_recon12.9 <- as.data.frame(allts(fcasts.gts[[1]])[,2:9]) #these are the reconciled fcasts for levels 2:9
all_recon22.9 <- as.data.frame((fcasts.gts[[2]])[,2:9]) #these are the base fcasts for levels 2:9



all_opt <- as.data.frame(allts(fcasts.opt[1:8,1,1])) #is this supposed to show all the iterations?

































#total
ggplot(data = dfa, aes(x = quarter, y = count)) + stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") +
  ggtitle("Australian adult prison population") +
  theme(plot.title = element_text(hjust = 0.5))

#group by state
ggplot(data = dfa, aes(x = quarter, y = count, group = state, colour = state))  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + ggtitle("Australian adult by state") + theme(plot.title = element_text(hjust = 0.5))

#group by gender
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + ggtitle("Australian adult prison population by gender") + theme(plot.title = element_text(hjust = 0.5))

#group by indigenous status
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + ggtitle("Australian adult prison population by indigenous status") + theme(plot.title = element_text(hjust = 0.5))

#group by indigenous status in each state
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous)) + facet_grid(.~state)  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%Y"), date_breaks= "24 months") + ggtitle("Australian adult prison population by state and indigenous status") + theme(plot.title = element_text(hjust = 0.5))

#group by legal status
ggplot(data = dfa, aes(x = quarter, y = count, group = legal, colour = legal))  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + ggtitle("Australian adult prison population by legal status") + theme(plot.title = element_text(hjust = 0.5))

#group by legal status in each state
ggplot(data = dfa, aes(x = quarter, y = count, group = legal, colour = legal)) + facet_grid(.~state)  + stat_summary(fun.y = sum, geom = "line") + scale_x_date(labels = date_format("%Y"), date_breaks= "24 months") + ggtitle("Australian adult prison population by state and legal status") + theme(plot.title = element_text(hjust = 0.5))


################

dfa <- read.csv("data_a.csv", strip.white = TRUE) # clean white spaces


dfa_w <- reshape(dfa, idvar = c("state", "sex", "legal", "indigenous"),
                 timevar = "date", direction = "wide") # make it wide format

dfa_w$pathString <- paste(dfa_w$state,#length=1
                          dfa_w$sex, #length=1
                          dfa_w$legal, #length=1
                          dfa_w$indigenous,#length=1
                              sep="") #add a pathString column

#clean the dataset
library(data.table)
#rename the columns

setnames(dfa_w, old=c("count.2005/03/01","count.2005/06/01","count.2005/09/01","count.2005/12/01", "count.2006/03/01", "count.2006/06/01", "count.2006/09/01", "count.2006/12/01", "count.2007/03/01", "count.2007/06/01", "count.2007/09/01", "count.2007/12/01", "count.2008/03/01", "count.2008/06/01", "count.2008/09/01", "count.2008/12/01", "count.2009/03/01", "count.2009/06/01", "count.2009/09/01", "count.2009/12/01", "count.2010/03/01", "count.2010/06/01", "count.2010/09/01", "count.2010/12/01", "count.2011/03/01", "count.2011/06/01", "count.2011/09/01", "count.2011/12/01", "count.2012/03/01","count.2012/06/01","count.2012/09/01","count.2012/12/01", "count.2013/03/01", "count.2013/06/01", "count.2013/09/01", "count.2013/12/01", "count.2014/03/01", "count.2014/06/01", "count.2014/09/01", "count.2014/12/01", "count.2015/03/01", "count.2015/06/01", "count.2015/09/01", "count.2015/12/01", "count.2016/03/01","count.2016/06/01","count.2016/09/01","count.2016/12/01"),
         new=c("2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01"))

myvars <- c("pathString","2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01")
newdata <- dfa_w[myvars]

#transpose the data
newdata2 <- t(newdata)

#rename the columns and remove the first row
colnames(newdata2) = newdata2[1,]
newdata2 = newdata2[-1,]

newdata2[newdata2 == 'n/a'] = NA
newdata2 = apply(newdata2, 2, as.numeric)

library(hts)
bts <- ts(newdata2, start=c(2005,1), end=c(2016,4), frequency=4)

nchar(newdata$pathString) #4


abc <- ts(5 + matrix(sort(rnorm(1600)), ncol = 16, nrow = 100))
sex <- rep(c("female", "male"), each = 8)
state <- rep(c("NSW", "VIC", "QLD", "SA", "WA", "NT", "ACT", "TAS"), 2)
gc <- rbind(sex, state)  # a matrix consists of strings.
gn <- rbind(rep(1:2, each = 8), rep(1:8, 2))  # a numerical matrix
rownames(gc) <- rownames(gn) <- c("Sex", "State")
x <- gts(abc, groups = gc)
y <- gts(abc, groups = gn)


y <- gts(bts, characters = c(1,1,1,1))

ncol(bts)

for(i in 1:1)
plot(bts[,i])


?gts
attributes(bts)
plot(y, levels=0)
plot(y, levels=1)
plot(y,levels=2)
plot(y, levels=3)
plot(y, levels=4)
plot(y, levels=5)
plot(y, levels=6)
plot(y, levels=7)
plot(y, levels=8)
plot(y, levels=9)
plot(y, levels=10)
plot(y, levels=11)

f_comb <- forecast(y, h=8, method="comb", fmethod="ets")


plot(f_comb, levels=0)
plot(f_comb, levels=1) #State
plot(f_comb, levels=2) #Sex
plot(f_comb, levels=3) #Legal
plot(f_comb, levels=4) #Indigenous
plot(f_comb, levels=5) #State + Sex
plot(f_comb, levels=6) #State + Legal
plot(f_comb, levels=7) #State + Indigenous
plot(f_comb, levels=8) #Sex + Legal
plot(f_comb, levels=9) #Sex + Indigenous
plot(f_comb, levels=10) #Legal + Indigenous
plot(f_comb, levels=11) #Bottom level

all <- allts(y)

print(all)

#which populations are of interest to policy makers
#modelling at the aggregate level - national and state
#by features - Indigenous NSW or Indigenous Australia

print(y)
attributes(y)
y[1]

plot(g1)

g1 <- aggts(y, levels=c(1))
g2 <- aggts(y, levels=c(2))
g3 <- aggts(y, levels=c(3))
g4 <- aggts(y, levels=c(4))
g5 <- aggts(y, levels=c(5))
g6 <- aggts(y, levels=c(6))
g7 <- aggts(y, levels=c(7))
g8 <- aggts(y, levels=c(8))
g9 <- aggts(y, levels=c(9))
g10 <- aggts(y, levels=c(10))
g11 <- aggts(y, levels=c(11))

g12 <- aggts(y, levels=c(12))

library(hts)
nsw <- g1[,1]
vic <- g1[,2]
qld <- g1[,3]
sa <- g1[,4]
wa <- g1[,5]
tas <- g1[,6]
nt <- g1[,7]
act <- g1[,8]

male <- g2[,1]
female <- g2[,2]

g3
remanded <- g3[,1]
sentenced <- g3[,3]
plot(sentenced)

g4
indigenous <- g4[,1]
non_indigenous <- g4[,2]
plot(non_indigenous)

g6
nsw_rem <- g6[,1]
nsw_sen <- g6[,3]
vic_rem <- g6[,4]
vic_sen <- g6[,6]
qld_rem <- g6[,7]
qld_sen <- g6[,9]
sa_rem <- g6[,10]
sa_sen <- g6[,12]
wa_rem <- g6[,13]
wa_sen <- g6[,15]
tas_rem <- g6[,16]
tas_sen <- g6[,18]
nt_rem <- g6[,19]
nt_sen <- g6[,21]
act_rem <- g6[,22]
act_sen <- g6[,24]

#####MODELLING OF THE STATES########
########NSW##########
library(ggplot2)

##exploring seasonality and trends###
seasonplot(nsw, col=1:20, year.labels=TRUE)
monthplot(nsw)
ggseasonplot(nsw, polar=TRUE) + ylab("Prisoner Count") + ggtitle("Nsw prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(vic, polar=TRUE) + ylab("Prisoner Count") + ggtitle("VIC prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(qld, polar=TRUE) + ylab("Prisoner Count") + ggtitle("QLD prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(sa, polar=TRUE) + ylab("Prisoner Count") + ggtitle("SA prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(wa, polar=TRUE) + ylab("Prisoner Count") + ggtitle("WA prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(tas, polar=TRUE) + ylab("Prisoner Count") + ggtitle("TAS prisoners season plot") ##some seasonability?
ggseasonplot(act, polar=TRUE) + ylab("Prisoner Count") + ggtitle("ACT prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(nt, polar=TRUE) + ylab("Prisoner Count") + ggtitle("NT prisoners season plot") ##doesn't appear to be any seasonability
ggseasonplot(nsw_rem, polar=TRUE) + ylab("Prisoner Count") + ggtitle("NSW Remand prisoners season plot") ##doesn't appear to be any seasonability



###decomposition###
fit_a <- decompose(nsw, type="additive")
plot(fit_a)
fit_m <- decompose(nsw, type="multiplicative")
plot(fit_m)

##testing and training ##
plot(nsw)
training <- window(nsw, end=2015.99) ## changing to expanding window # generate 1 - 4 steps ahead
testing <- window(nsw, start=2016)
lines(testing,col="blue")

##simple methods ###
f1 <-meanf(training, h=4)
accuracy(f1,testing)
f2 <-naive(training, h=4)
accuracy(f2,testing)
f3 <-snaive(training, h=4)
accuracy(f3, testing)
f4 <- rwf(training, drift=TRUE, h=4)
accuracy(f4, testing)

plot(nsw)
abline(v=2016)
lines(f1$mean, col=4)
lines(f2$mean, col=5)
lines(f3$mean, col=6)
lines(f4$mean, col=7)
legend("topleft", lty=1, col=c(4,5,6,7), legend=c("Mean", "Naive", "Seasonal Naive", "Random Walk with Drift"))

###STL Decomposition###
fit_astl <- stl(training, s.window="periodic", t.window=5)
l <- BoxCox.lambda(training)
fit_mstl <- stl(BoxCox(training, l), s.window="periodic")
fit_mstlrob <- stl(BoxCox(training, l), s.window="periodic", robust=TRUE)
fit_mstlt5 <- stl(BoxCox(training, l), s.window="periodic", t.window=5, robust=FALSE)
fit_mstlt7 <- stl(BoxCox(training, l), s.window="periodic", t.window=7)
fit_mstlt9 <- stl(BoxCox(training, l), s.window="periodic", t.window=9)
fit_mstlt11 <- stl(BoxCox(training, l), s.window="periodic", t.window=11)
fit_mstlt13 <- stl(BoxCox(training, l), s.window="periodic", t.window=13)

plot(fit_astl, main="Additive STL decomposition")
plot(fit_mstl, main="Multiplicative STL decomposition")
plot(fit_mstlrob, main="Multiplicative STL decomposition (rob=true)")
plot(fit_mstl, main="Multiplicative STL decomposition")
plot(fit_mstl, main="Multiplicative STL decomposition")
plot(fit_mstlt5, main="Multiplicative STL decomposition (t.window=5)")
plot(fit_mstlt7, main="Multiplicative STL decomposition (t.window=7)")
plot(fit_mstlt9, main="Multiplicative STL decomposition (t.window=9)")
plot(fit_mstlt11, main="Multiplicative STL decomposition (t.window=11)")
plot(fit_mstlt13, main="Multiplicative STL decomposition (t.window=13)")


f5 <- stlf(training, s.window="periodic", h=4, t.window=5, robust=FALSE, lambda=l)
plot(nsw, main="NSW prison population", ylab="Prisoners", ylim=c(8000,16000))
lines(f5$mean, col="2")
legend("topleft", lty=1, col=c(2), legend=c("STL Forecasts"))
plot(f5)

rstl <- residuals(f5)
plot(rstl, main="Residual analysis of STL forecasts", ylab="Residuals")
abline(h=0)
Acf(rstl, main="Series: Residuals from STL forecast method")
hist(rstl, breaks="FD", main="Histogram of residuals from STL forecast method")
Box.test(rstl, type="Ljung")

###ETS###
ets_auto <- ets(training, ic=c("aic"))
plot(ets_auto)
f6 <- forecast(ets_auto, h=4, level=c(80,95))
plot(f6)
lines(testing, col=2)
legend("topleft", lty=1, col=c(2,"blue"), legend=c("Testing data", "Forecasts ETS(M,A,M)"))

##ARIMA##
library(tseries)
tsdisplay(training)
plot(training, main="NSW prisoners", ylab="Prisoners")
adf.test(training)
kpss.test(training)

plot(log(training), main="NSW prison population - log", ylab="Prisoners")
tsdisplay(log(training))
adf.test(log(training))
kpss.test(log(training))

#Difference with no transformation
plot(diff(training, 4), main="NSW prison population | Seasonal-Difference = 1", ylab="Prisoners")
tsdisplay(diff(training, 4))
adf.test(diff(training, 4))
kpss.test(diff(training, 4))

#Diff with Box-Cox transformation
plot(diff(BoxCox(training, lambda=l), 4), main="NSW prison population | Seasonal-Difference = 1 | Box-Cox transformation", ylab="Prisoners")
tsdisplay(diff(BoxCox(training, lambda=l), 4))
adf.test(diff(BoxCox(training, lambda=l), 4))
kpss.test(diff(BoxCox(training, lambda=l), 4))

#Seasonal and second order differencing with log transformation
plot(diff(diff(log(training), 4)), main="NSW prison population | Seasonal-Difference = 2 | Log transformation", ylab="Prisoners")
abline(h=0)

#Seasonal and first order differencing with Box-Cox transformation
plot(diff(diff(BoxCox(training, lambda=l), 4)), main="NSW prison population | Box-Cox transformation | Seasonal and first order diff", ylab="Prisoners")
abline(h=0)
tsdisplay(diff(diff(BoxCox(training, lambda=l), 4)))

Acf(diff(diff(BoxCox(training, lambda=l), 4)))
Pacf(diff(diff(BoxCox(training, lambda=l), 4)))

#ARIMA

arima120120 <- Arima(training, lambda=l, order=c(1,1,0), seasonal=c(1,1,0))
r1 <- residuals(arima120120)
tsdisplay(r1)
summary(arima120120)
Box.test(r1, lag=8, fitdf=3, type="Ljung")

f7 <- forecast(arima120120, h=8, level=c(80,95))
plot(f7)
lines(testing)

autoar <- auto.arima(training, stepwise=TRUE, trace=FALSE, lambda=l, ic="aicc", seasonal=TRUE, stationary=FALSE)
f8 <- forecast(autoar, h=4)
r_auto <- residuals(f8)
tsdisplay(r_auto)
summary(f8)
Box.test(r_auto, lag=8, fitdf=2, type="Ljung")

plot(f8)

########## regressions #######
pop <- read.csv("popv2.csv", strip.white = TRUE) #population
names(pop)[1] <- "date"

pop1 <- ts(pop, start=c(2005,1), end=c(2016,4), frequency=4)

plot(pop1)

inc <- read.csv("incomev2.csv", strip.white = TRUE) #income
names(inc)[1] <- "date"

inc1 <- ts(inc, start=c(2005,1), end=c(2016,4), frequency=4)

plot(inc1)

#ur <- read.csv("unemployment_rate.csv", strip.white = TRUE) #unemployment rate
#names(ur)[1] <- "date"

#ur$date <- as.Date(ur$date, format = "%Y/%m/%d")

#ur$quarter <- as.Date(cut(ur$date, breaks = "quarter"))

#ur2 <- aggregate(x = ur[c("ur_nsw","ur_vic", "ur_qld", "ur_sa", "ur_wa", "ur_tas", "ur_nt", "ur_act", "ur_aus")],
 #                    FUN = mean,
  #                   by = list(Group.date = ur$quarter))

#names(ur2)[1] <- "date"

#write.csv(ur2, "ur2.csv")

ur <- read.csv("ur2.csv", strip.white = TRUE) #unemployment rate

library("tseries")

adf.test(diff(diff(nsw))) #stationary after second order differencing

adf.test(diff(diff(diff(pop$pop_nsw)))) #stationary after third order differencing

adf.test(diff(diff(ur$ur_nsw))) #stationary after second order differencing

adf.test(diff(diff(inc$inc_nsw))) #stationary after second order differencing

#install.packages("urca") https://www.quantstart.com/articles/Johansen-Test-for-Cointegrating-Time-Series-Analysis-in-R
library(urca)

jotest=ca.jo(data.frame(nsw,pop$pop_nsw), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest)

jotest=ca.jo(data.frame(nsw,ur$ur_nsw), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest)

jotest=ca.jo(data.frame(nsw,inc$inc_nsw), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest)

##doesn't seem to be any cointegration between NSW prison population and the economic indicators

arima_pop <- auto.arima(nsw, xreg=pop[,'pop_nsw'])
arima_pop

arima_ur <- auto.arima(nsw, xreg=ur[,'ur_nsw'])
arima_ur

arima_inc <- auto.arima(nsw, xreg=inc[,'inc_nsw'])
arima_inc #income appears to be significant?


############
############
#####VIC####
############
############

library("tseries")
adf.test(diff(vic))
adf.test(diff(diff(vic))) #stationary after second order differencing

adf.test(diff(diff(pop$pop_vic)))
adf.test(diff(diff(diff(pop$pop_vic)))) #stationary after third order differencing

adf.test(diff(ur$ur_vic))
adf.test(diff(diff(ur$ur_vic))) #stationary after second order differencing

adf.test(diff(inc$inc_vic))
adf.test(diff(diff(inc$inc_vic))) #stationary after second order differencing

#install.packages("urca") https://www.quantstart.com/articles/Johansen-Test-for-Cointegrating-Time-Series-Analysis-in-R
library(urca)

jotest=ca.jo(data.frame(vic,pop$pop_vic), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #maybe there is evidence of cointegration?

jotest=ca.jo(data.frame(vic,ur$ur_vic), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #no cointegration

jotest=ca.jo(data.frame(vic,inc$inc_vic), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #no cointegration

##doesn't seem to be any cointegration between NSW prison population and the economic indicators

arima_pop <- auto.arima(vic, xreg=pop[,'pop_vic'])
arima_pop #population does seem to have an effect

arima_ur <- auto.arima(vic, xreg=ur[,'ur_vic'])
arima_ur #unemployment doesn't have an effect

arima_inc <- auto.arima(vic, xreg=inc[,'inc_vic'])
arima_inc #income does not have an effect?

############
############
#####QLD####
############
############

library("tseries")
adf.test(diff(qld))
adf.test(diff(diff(qld))) #stationary after second order differencing

adf.test(diff(diff(pop$pop_qld)))
adf.test(diff(diff(diff(pop$pop_qld)))) #stationary after third order differencing

adf.test(diff(ur$ur_qld))
adf.test(diff(diff(ur$ur_qld))) #stationary after second order differencing

adf.test(diff(inc$inc_qld))
adf.test(diff(diff(inc$inc_qld))) #stationary after second order differencing

#install.packages("urca") https://www.quantstart.com/articles/Johansen-Test-for-Cointegrating-Time-Series-Analysis-in-R
library(urca)

jotest=ca.jo(data.frame(qld,pop$pop_qld), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #no evidence of cointegration?

jotest=ca.jo(data.frame(qld,ur$ur_qld), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #no cointegration

jotest=ca.jo(data.frame(qld,inc$inc_qld), type="trace", K=2, ecdet="none", spec="longrun")
summary(jotest) #maybe evidence at the 10% level of cointegration?

##doesn't seem to be any cointegration between NSW prison population and the economic indicators

arima_pop <- auto.arima(qld, xreg=pop[,'pop_qld'])
arima_pop #population does seem to have an effect

arima_ur <- auto.arima(qld, xreg=ur[,'ur_qld'])
arima_ur #unemployment doesn't have an effect

arima_inc <- auto.arima(qld, xreg=inc[,'inc_qld'])
arima_inc #income does not have an effect?

##set baseline forecasts
#test reconciled forecasts against benchmark

