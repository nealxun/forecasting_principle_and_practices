---
title: Forecasting with ARIMA models
description: >-
  ARIMA models provide another approach to time series forecasting. Exponential
  smoothing and ARIMA models are the two most widely-used approaches to time
  series forecasting, and provide complementary approaches to the problem. While
  exponential smoothing models are based on a description of the trend and
  seasonality in the data, ARIMA models aim to describe the autocorrelations in
  the data.
attachments :
  slides_link : https://s3.amazonaws.com/assets.datacamp.com/production/course_3002/slides/ch4.pdf

--- type:VideoExercise lang:r xp:50 skills:1 key:61236a7cde
## Transformations for variance stabilization

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v3/hls-ch4_1.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:61c1ec383d
## Box-Cox transformations for time series

Here, you will use a **Box-Cox transformation** to stabilize the variance of the pre-loaded `a10` series, which contains monthly anti-diabetic drug sales in Australia from 1991-2008.

In this exercise, you will need to experiment to see the effect of the `lambda` ($\lambda$) argument on the transformation. Notice that small changes in $\lambda$ make little difference to the resulting series. You want to find a value of $\lambda$ that makes the seasonal fluctuations of roughly the same size across the series.

Recall from the video that the recommended range for `lambda` values is $-1 ≤ \lambda ≤ 1$.

*** =instructions

- Plot the `a10` series and observe the increasing variance as the level of the series increases.
- Try transforming the series using `BoxCox()` in the format of the sample code. Experiment with *four* values of `lambda`: `0.1`, `0.2`, `0.3`, and `0.4`. Can you determine which lambda value approximately stabilizes the variance?
- Now compare your chosen value of `lambda` with the one returned by `BoxCox.lambda()`.

*** =hint

In practice, you would normally use a simple value of `lambda` such as 0, 0.5 or 1. Forecasts are relatively insensitive to finer resolutions for `lambda`.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the series
___

# Try four values of lambda in Box-Cox transformations
a10 %>% BoxCox(lambda = ___) %>% autoplot()
___
___
___

# Compare with BoxCox.lambda()
___
```

*** =solution
```{r}
# Plot the series
autoplot(a10)

# Try four values of lambda in Box-Cox transformations
a10 %>% BoxCox(lambda = 0.0) %>% autoplot()
a10 %>% BoxCox(lambda = 0.1) %>% autoplot()
a10 %>% BoxCox(lambda = 0.2) %>% autoplot()
a10 %>% BoxCox(lambda = 0.3) %>% autoplot()

# Compare with BoxCox.lambda()
BoxCox.lambda(a10)
```

*** =sct
```{r}
ex() %>% {
  check_error(.)
  
  check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on `a10`?", append = FALSE)
  
  check_function(., "BoxCox") %>% {
    check_arg(., "x") %>% check_equal(incorrect_msg = "Did you pipe `a10` into your first call to `BoxCox()`?", append = FALSE)
    check_arg(., "lambda") %>% check_equal(incorrect_msg = "Did you specify `lambda` as `0.0` in your first call to `BoxCox()`?", append = FALSE)
  }
  check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of your first `BoxCox()` call to `autoplot()`?", append = FALSE)
  
  check_function(., "BoxCox", index = 2) %>% {
    check_arg(., "x") %>% check_equal(incorrect_msg = "Did you pipe `a10` into your second call to `BoxCox()`?", append = FALSE)
    check_arg(., "lambda") %>% check_equal(incorrect_msg = "Did you specify `lambda` as `0.1` in your second call to `BoxCox()`?", append = FALSE)
  }
  check_function(., "autoplot", index = 3) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of your second `BoxCox()` call to `autoplot()`?", append = FALSE)
  
  check_function(., "BoxCox", index = 3) %>% {
    check_arg(., "x") %>% check_equal(incorrect_msg = "Did you pipe `a10` into your third call to `BoxCox()`?", append = FALSE)
    check_arg(., "lambda") %>% check_equal(incorrect_msg = "Did you specify `lambda` as `0.2` in your third call to `BoxCox()`?", append = FALSE)
  }
  check_function(., "autoplot", index = 4) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of your third `BoxCox()` call to `autoplot()`?", append = FALSE)
  
  check_function(., "BoxCox", index = 4) %>% {
    check_arg(., "x") %>% check_equal(incorrect_msg = "Did you pipe `a10` into your fourth call to `BoxCox()`?", append = FALSE)
    check_arg(., "lambda") %>% check_equal(incorrect_msg = "Did you specify `lambda` as `0.3` in your fourth call to `BoxCox()`?", append = FALSE)
  }
  check_function(., "autoplot", index = 5) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of your fourth `BoxCox()` call to `autoplot()`?", append = FALSE)
  
  check_function(., "BoxCox.lambda") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you call `BoxCox.lambda()` on `a10`?", append = FALSE)
  
}

success_msg("Good job! It seems like a lambda of .13 would work well.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:560e0ce6a8
## Non-seasonal differencing for stationarity

**Differencing** is a way of making a time series stationary; this means that you remove any systematic patterns such as trend and seasonality from the data. A white noise series is considered a special case of a stationary time series.

With non-seasonal data, you use lag-1 differences to model changes between observations rather than the observations directly. You have done this before by using the `diff()` function.

In this exercise, you will use the pre-loaded `wmurders` data, which contains the annual female murder rate in the US from 1950-2004.

*** =instructions

- Plot the `wmurders` data and observe how it has changed over time.
- Now, plot the annual changes in the murder rate using the function mentioned above and observe that these are much more stable.
- Finally, plot the ACF of the changes in murder rate using a function that you learned in the first chapter.

*** =hint

- In these exercises, use combinations of the `autoplot()`, `diff()`, and `ggAcf()` functions.
- It may be surprising that a time series with apparent short-term trends can actually resemble white noise after differencing. This is true of many economic and financial time series as well. Beware of over-interpreting the short-term trends.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the US female murder rate
___

# Plot the differenced murder rate
___

# Plot the ACF of the differenced murder rate
___
```

*** =solution
```{r}
# Plot the US female murder rate
autoplot(wmurders)

# Plot the differenced murder rate
autoplot(diff(wmurders))

# Plot the ACF of the differenced murder rate
ggAcf(diff(wmurders))
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the `wmurders` series?", append = FALSE)
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the differenced `wmurders` series?", append = FALSE)
    check_function(., "ggAcf") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you plot the ACF of the differenced `wmurders` series?", append = FALSE)
}

success_msg("Great! It seems like the data look like white noise after differencing.")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:482e043a65
## Seasonal differencing for stationarity

With seasonal data, differences are often taken between observations in the same season of consecutive years, rather than in consecutive periods. For example, with quarterly data, one would take the difference between Q1 in one year and Q1 in the previous year. This is called **seasonal differencing**.

Sometimes you need to apply both seasonal differences and lag-1 differences to the same series, thus, calculating the differences in the differences.

In this exercise, you will use differencing and transformations simultaneously to make a time series look stationary. The data set here is `h02`, which contains 17 years of monthly corticosteroid drug sales in Australia. It has been loaded into your workspace.

*** =instructions

- Plot the data to observe the trend and seasonality.
- Take the `log()` of the `h02` data and then apply seasonal differencing by using an appropriate `lag` value in `diff()`. Assign this to `difflogh02`.
- Plot the resulting logged and differenced data.
- Because `difflogh02` still looks non-stationary, take another lag-1 difference by applying `diff()` to itself and save this to `ddifflogh02`. Plot the resulting series.
- Plot the ACF of the final `ddifflogh02` series using the appropriate function.

*** =hint

- Take logs before taking differences. This will require a function inside another function.
- Set the `lag` argument in `diff()` equal 12 because the seasonal pattern in the series is monthly.
- To plot the ACF of a series, use `ggAcf()` instead of `autoplot()`.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the data
___

# Take logs and seasonal differences of h02
difflogh02 <- diff(log(___), lag = ___)

# Plot difflogh02
___

# Take another difference and plot
ddifflogh02 <- ___
___

# Plot ACF of ddifflogh02
___
```

*** =solution
```{r}
# Plot the data
autoplot(h02)

# Take logs and seasonal differences of h02
difflogh02 <- diff(log(h02), lag = 12)

# Plot difflogh02
autoplot(difflogh02)

# Take another difference and plot
ddifflogh02 <- diff(difflogh02)
autoplot(ddifflogh02)

# Plot ACF of ddifflogh02
ggAcf(ddifflogh02)
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the `h02` series?", append = FALSE)
    
    check_function(., "diff") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Are you differencing the log of the `h02` series?", append = FALSE)
        check_arg(., "lag") %>% check_equal(incorrect_msg = "What is the seasonal pattern in the series? How many lags should you use?", append = FALSE)
    }
    check_object(., "difflogh02")
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the `difflogh02` series?", append = FALSE)
    
    check_function(., "diff", index = 2) %>% check_arg("x") %>% check_equal(incorrect_msg = "Are you differencing the `difflogh02` series?", append = FALSE)
    check_object(., "ddifflogh02")
    check_function(., "autoplot", index = 3) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the `ddifflogh02` series?", append = FALSE)
    
    check_function(., "ggAcf") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you plot the ACF of `ddifflogh02` series?", append = FALSE)
}

success_msg("Great! The data doesn't look like white noise after the transformation, but you could develop an ARIMA model for it.")

```
--- type:VideoExercise lang:r xp:50 skills:1 key:d51963acfe
## ARIMA models

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch4_2.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:1d54c4f028
## Automatic ARIMA models for non-seasonal time series

In the video, you learned that the `auto.arima()` function will select an appropriate **autoregressive integrated moving average (ARIMA)** model given a time series, just like the `ets()` function does for ETS models. The `summary()` function can provide some additional insights:

```
> # p = 2, d = 1, p = 2
> summary(fit)

Series: usnetelec
ARIMA(2,1,2) with drift
...
```

In this exercise, you will automatically choose an ARIMA model for the pre-loaded `austa` series, which contains the annual number of international visitors to Australia from 1980-2015. You will then check the residuals (recall that a p-value greater than 0.05 indicates that the data resembles white noise) and produce some forecasts. Other than the modelling function, this is identicial to what you did with ETS forecasting.

*** =instructions

- Fit an automatic ARIMA model to the `austa` series using the newly introduced function. Save this to `fit`.
- Use the appropriate function to check that the residuals of the resulting model look like white noise. Assign `TRUE` (if the residuals look like white noise) or `FALSE` (if they don't) to `residualsok`.
- Apply `summary()` to the model to see the fitted coefficients.
- Based on the results using `summary()`, what is the AICc value to two decimal places? How many differences were used? Assign these to `AICc` and `d`, respectively.
- Finally, using the pipe operator, plot forecasts of the next 10 periods from the chosen model.

*** =hint

- To plot the forecasts, you will need to use both the `autoplot()` and `forecast()` functions.
- To determine if the residuals of `fit` resemble white noise, use the `checkresiduals()` function to confirm that the p-value is greater than 0.05.
- To determine the number of differences, look through the results of `summary()` for `ARIMA(0,1,1) with drift`. The second integer is `d` for differences.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Fit an automatic ARIMA model to the austa series
fit <- ___

# Check that the residuals look like white noise
___
residualsok <- ___

# Summarize the model
___

# Find the AICc value and the number of differences used
AICc <- ___
d <- ___

# Plot forecasts of fit
fit %>% forecast(h = ___) %>% ___()
```

*** =solution
```{r}
# Fit an automatic ARIMA model to the austa series
fit <- auto.arima(austa)

# Check that the residuals look like white noise
checkresiduals(fit)
residualsok <- TRUE

# Summarize the model
summary(fit)

# Find the AICc value and the number of differences used
AICc <- -14.46
d <- 1

# Plot forecasts of fit
fit %>% forecast(h = 10) %>% autoplot()
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "auto.arima") %>% check_arg("y") %>% check_equal(incorrect_msg = "Did you call `auto.arima()` on `austa`?", append = FALSE)
    check_object(., "fit")
    
    check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you check the residuals of `fit` with the appropriate function?", append = FALSE)
    check_object(., "residualsok") %>% check_equal(incorrect_msg = "Check the p-value results of the Ljung-Box test. Do the residuals look like white noise?", append = FALSE)
    
    check_code(., "summary(fit)", append = FALSE, fixed = TRUE, missing_msg = "Did you call `summary()` on `fit`?")
    
    check_object(., "AICc") %>% check_equal(incorrect_msg = "You should be able to get the AICc from `summary(fit)`.", append = FALSE)
    check_object(., "d") %>% check_equal(incorrect_msg = "The ARIMA model specification shown in the summary contains the number of differences used. `d` is the second integer.", append = FALSE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Did you pipe `fit` to `forecast()`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should be forecasting the next 10 periods. Set `h` correctly.", append = FALSE)
    }
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of `forecast()` into `autoplot()`?", append = FALSE)
    
}

success_msg("Good job. It looks like the ARIMA model created a pretty good forecast for you.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:60770ac294
## Forecasting with ARIMA models

The automatic method in the previous exercise chose an ARIMA(0,1,1) with drift model for the `austa` data, that is,
$y\_t = c + y\_{t-1} + \theta e\_{t-1} + e\_t.$
You will now experiment with various other ARIMA models for the data to see what difference it makes to the forecasts.

The `Arima()` function can be used to select a specific ARIMA model. Its first argument, `order`, is set to a vector that specifies the values of $p$, $d$ and $q$. The second argument, `include.constant`, is a booolean that determines if the constant $c$, or **drift**, should be included. Below is an example of a pipe function that would plot forecasts of `usnetelec` from an ARIMA(2,1,2) model with drift:

```
> usnetelec %>%
    Arima(order = c(2,1,2), include.constant = TRUE) %>%
    forecast() %>%
    autoplot()
```

In the examples here, watch for how the different models affect the forecasts and the prediction intervals. The `austa` data is ready for you to use in your workspace.


*** =instructions

- Plot forecasts from an ARIMA(0,1,1) model with no drift.
- Plot forecasts from an ARIMA(2,1,3) model with drift.
- Plot forecasts from an ARIMA(0,0,1) model with a constant.
- Plot forecasts from an ARIMA(0,2,1) model with no constant.

*** =hint

- Each correct answer here will utilize the `forecast()` and `autoplot()` functions.
- A model with $d=0$ and no constant will have forecasts that converge to $0$.
- A model with $d=0$ and a constant will have forecasts that converge to the mean of the data.
- A model with $d=1$ and no constant will have forecasts that converge to a non-zero value close to the last observation.
- A model with $d=1$ and a constant will have forecasts that converge to a linear function with slope based on the whole series.
- A model with $d=2$ and no constant will have forecasts that converge to a linear function with slope based on the last few observations.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot forecasts from an ARIMA(0,1,1) model with no drift
austa %>% Arima(order = c(___, ___, ___), include.constant = ___) %>% ___ %>% ___

# Plot forecasts from an ARIMA(2,1,3) model with drift
austa %>% Arima(___, ___) %>% ___ %>% ___

# Plot forecasts from an ARIMA(0,0,1) model with a constant
austa %>% Arima(___, ___) %>% ___ %>% ___

# Plot forecasts from an ARIMA(0,2,1) model with no constant
austa %>% Arima(___, ___) %>% ___ %>% ___
```

*** =solution
```{r}
# Plot forecasts from an ARIMA(0,1,1) model with no drift
austa %>% Arima(order = c(0,1,1), include.constant = FALSE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(2,1,3) model with drift
austa %>% Arima(order = c(2,1,3), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,0,1) model with a constant
austa %>% Arima(order = c(0,0,1), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,2,1) model with no constant
austa %>% Arima(order = c(0,2,1), include.constant = FALSE) %>% forecast() %>% autoplot()
```

*** =sct
```{r}
test_error()

test_function("Arima",    args = "y",                index = 1, incorrect_msg = "Are you fitting an ARIMA to `austa`?")
test_function("Arima",    args = "order",            index = 1, incorrect_msg = "Did you specify a `c(0,1,1)` order?")
test_function("Arima",    args = "include.constant", index = 1, incorrect_msg = "The first model should not have a constant.")
test_function("forecast", args = "object",           index = 1, incorrect_msg = "Did you forecast the first Arima model?", eval = FALSE)
test_function("autoplot", args = "object",           index = 1, incorrect_msg = "Did you plot the first forecast?", eval = FALSE)

test_function("Arima",    args = "y",                index = 2, incorrect_msg = "Are you fitting an ARIMA to `austa`?")
test_function("Arima",    args = "order",            index = 2, incorrect_msg = "Did you specify a `c(2,1,3)` order?")
test_function("Arima",    args = "include.constant", index = 2, incorrect_msg = "The second model should have a constant.")
test_function("forecast", args = "object",           index = 2, incorrect_msg = "Did you forecast the second Arima model?", eval = FALSE)
test_function("autoplot", args = "object",           index = 2, incorrect_msg = "Did you plot the second forecast?", eval = FALSE)

test_function("Arima",    args = "y",                index = 3, incorrect_msg = "Are you fitting an ARIMA to `austa`?")
test_function("Arima",    args = "order",            index = 3, incorrect_msg = "Did you specify a `c(0,0,1)` order?")
test_function("Arima",    args = "include.constant", index = 3, incorrect_msg = "The third model should have a constant.")
test_function("forecast", args = "object",           index = 3, incorrect_msg = "Did you forecast the third Arima model?", eval = FALSE)
test_function("autoplot", args = "object",           index = 3, incorrect_msg = "Did you plot the third forecast?", eval = FALSE)

test_function("Arima",    args = "y",                index = 4, incorrect_msg = "Are you fitting an ARIMA to `austa`?")
test_function("Arima",    args = "order",            index = 4, incorrect_msg = "Did you specify a `c(0,2,1)` order?")
test_function("Arima",    args = "include.constant", index = 4, incorrect_msg = "The fourth model should not have a constant.")
test_function("forecast", args = "object",           index = 4, incorrect_msg = "Did you forecast the fourth Arima model?", eval = FALSE)
test_function("autoplot", args = "object",           index = 4, incorrect_msg = "Did you plot the fourth forecast?", eval = FALSE)

success_msg("Good job. The model specification makes a big impact on the forecast!")

```

--- type:NormalExercise lang:r xp:100 skills:1 key:20af44ebaa
## Comparing auto.arima() and ets() on non-seasonal data

The AICc statistic is useful for selecting between models in the *same* class. For example, you can use it to select an ETS model or to select an ARIMA model. However, you cannot use it to compare ETS and ARIMA models because they are in *different* model classes.

Instead, you can use time series cross-validation to compare an ARIMA model and an ETS model on the `austa` data. Because `tsCV()` requires functions that return forecast objects, you will set up some simple functions that fit the models and return the forecasts. The arguments of `tsCV()` are a time series, forecast function, and forecast horizon `h`. Examine this code snippet from the second chapter:

```
e <- matrix(NA_real_, nrow = 1000, ncol = 8)
for (h in 1:8)
  e[, h] <- tsCV(goog, naive, h = h)
  ...
```

Furthermore, recall that pipe operators in R take the value of whatever is on the left and pass it as an argument to whatever is on the right, step by step, from left to right. Here's an example based on code you saw in an earlier chapter:

```
# Plot 20-year forecasts of the lynx series modeled by ets()
lynx %>% ets() %>% forecast(h = 20) %>% autoplot()
```

In this exercise, you will compare the MSE of two forecast functions applied to `austa`, and plot forecasts of the function that computes the best forecasts. Once again, `austa` has been loaded into your workspace.


*** =instructions

- Fill in the `farima()` function to forecast the results of `auto.arima()`. Follow the structure of the pre-written code in `fets()` that does the same for `ets()`.
- Compute cross-validated errors for ETS models on `austa` using `tsCV()` with one-step errors, and save this to `e1`.
- Compute cross-validated errors for ARIMA models on `austa` using `tsCV()` with one-step errors, and save this to `e2`.
- Compute the cross-validated MSE for each model class and remove missing values. Refer to the previous chapter if you cannot remember how to calculate MSE.
- Produce and plot 10-year forecasts of future values of `austa` using the best model class.

*** =hint

- When computing MSE in `mean()`, set `e1^2` or `e2^2` as the first argument and `na.rm = TRUE` as the second.
- The three arguments for `tsCV` are the data set `austa`, one of the two forecast functions that you built - either `fets()` or `farima()`, and `h = 1`, respectively.
- Here, the MSE of `e2` is smaller than the MSE of `e1`, so you should use the corresponding function `farima()` in your pipe operator.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(___, ___)
}

# Compute CV errors for ETS as e1
e1 <- tsCV(___, ___, ___)

# Compute CV errors for ARIMA as e2
e2 <- tsCV(___, ___, ___)

# Find MSE of each model class
mean(___, ___)
mean(___, ___)

# Plot 10-year forecasts using the best model class
austa %>% ___ %>% ____
```

*** =solution
```{r}
# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x), h = h)
}

# Compute CV errors for ETS as e1
e1 <- tsCV(austa, fets, h = 1)

# Compute CV errors for ARIMA as e2
e2 <- tsCV(austa, farima, h = 1)

# Find MSE of each model class
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Plot 10-year forecasts using the best model class
austa %>% farima(h = 10) %>% autoplot()
```

*** =sct
```{r}
msg1 <- "In your %s `tsCV()` call, are you calculating CV errors for `austa`?"
msg2 <- "In your %s `tsCV()` call, did you set the second argument to `%s`?"
msg3 <- "In your %s `tsCV()` call, are you using one-step errors? Set `h` to `1`?"
msg4 <- "Did you take the mean of `%s`?"
msg5 <- "Did you remove missing values when taking the mean of `%s`? Set the second argument `na.rm` equal to `TRUE`."

ex() %>% {
    check_error(.)
    
    check_fun_def(., "fets") %>% { 
        check_arguments(.) 
        check_body(.) %>% { 
            check_function(., "forecast") %>% { 
                check_arg(., "object") %>% check_equal(incorrect_msg = "The first argument to `forecast()` inside `fets()` should be set to `ets(x)`.", append = FALSE, eval = FALSE) 
                check_arg(., "h") %>% check_equal(incorrect_msg = "The `h` argument to `forecast()` inside `fets()` should be set to `h`.", append = FALSE, eval = FALSE) 
            } 
        } 
    }
    
    check_fun_def(., "farima") %>% { 
        check_arguments(.) 
        check_body(.) %>% { 
            check_function(., "forecast") %>% { 
                check_arg(., "object") %>% check_equal(incorrect_msg = "The first argument to `forecast()` inside `farima()` should be set to `auto.arima(x)`.", append = FALSE, eval = FALSE) 
                check_arg(., "h") %>% check_equal(incorrect_msg = "The `h` argument to `forecast()` inside `farima()` should be set to `h`.", append = FALSE, eval = FALSE) 
            } 
        } 
    }
    
    check_function(., "tsCV") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg1, "first"), append = FALSE)
        check_arg(., "forecastfunction") %>% check_equal(incorrect_msg = sprintf(msg2, "first", "fets"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = sprintf(msg3, "first"), append = FALSE)
    }
    check_object(., "e1") %>% check_equal(incorrect_msg = sprintf(msg3, "first"), append = FALSE)
    
    check_function(., "tsCV", index = 2) %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg1, "second"), append = FALSE)
        check_arg(., "forecastfunction") %>% check_equal(incorrect_msg = sprintf(msg2, "second", "farima"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = sprintf(msg3, "second"), append = FALSE)
    }
    check_object(., "e2") %>% check_equal(incorrect_msg = sprintf(msg3, "second"), append = FALSE)
    
    check_function(., "mean") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg4, "e1"), append = FALSE)
        check_arg(., "na.rm") %>% check_equal(incorrect_msg = sprintf(msg5, "e1"), append = FALSE)
    }
    
    check_function(., "mean", index = 2) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg4, "e2"), append = FALSE)
        check_arg(., "na.rm") %>% check_equal(incorrect_msg = sprintf(msg5, "e2"), append = FALSE)
    }
    
    check_function(., "farima") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you pipe `austa` into `farima()`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should be forecasting the next 10 periods. Set `h` correctly.", append = FALSE)
    }
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of `farima()` into `autoplot()`?", append = FALSE, eval = FALSE)
}

success_msg("Great! Now you know how to compare across model classes.")

```

--- type:VideoExercise lang:r xp:50 skills:1 key:6cf1f1570d
## Seasonal ARIMA models

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v3/hls-ch4_3.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:650360af0e
## Automatic ARIMA models for seasonal time series

As you learned in the video, the `auto.arima()` function also works with seasonal data. Note that setting `lambda = 0` in the `auto.arima()` function - applying a log transformation - means that the model will be fitted to the transformed data, and that the forecasts will be back-transformed onto the original scale.

After applying `summary()` to this kind of fitted model, you may see something like the output below which corresponds with $(p,d,q)(P,D,Q)[m]$:

```
ARIMA(0,1,4)(0,1,1)[12]
```

In this exercise, you will use these functions to model and forecast the pre-loaded `h02` data, which contains monthly sales of cortecosteroid drugs in Australia.

*** =instructions

- Using the standard plotting function, plot the logged `h02` data to check that it has stable variance.
- Fit a seasonal ARIMA model to the `h02` series with `lambda = 0`. Save this to `fit`.
- Summarize the fitted model using the appropriate method.
- What levels of differencing were used in the model? Assign the amount of lag-1 differencing to `d` and seasonal differencing to `D`.
- Plot forecasts for the next 2 years by using the fitted model. Set `h` accordingly.

*** =hint

- Use the `log()`, `auto.arima()`, and `summary` functions for the first three parts of the exercise.
- `auto.arima()` automates the modelling, apart from the choice of Box-Cox transformation. You have to do that yourself via the `lambda` argument.
- Set the `h` argument in the `forecast()` function equal to the number of months in the given timeframe.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Check that the logged h02 data have stable variance
h02 %>% ___ %>% ___

# Fit a seasonal ARIMA model to h02 with lambda = 0
fit <- ___

# Summarize the fitted model
___

# Record the amount of lag-1 differencing and seasonal differencing used
d <- ___
D <- ___

# Plot 2-year forecasts
fit %>% ___ %>% ___
```

*** =solution
```{r}
# Check that the logged h02 data have stable variance
h02 %>% log() %>% autoplot()

# Fit a seasonal ARIMA model to h02 with lambda = 0
fit <- auto.arima(h02, lambda = 0)

# Summarize the fitted model
summary(fit)

# Record the amount of lag-1 differencing and seasonal differencing used
d <- 1
D <- 1

# Plot 2-year forecasts
fit %>% forecast(h = 24) %>% autoplot()
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "log") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you look at the `log()` of the `h02` series?", append = FALSE)
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on the `log()` of the `h02` series?", append = FALSE)
    
    check_function(., "auto.arima") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Did you fit a seasonal ARIMA model to `h02`?", append = FALSE)
        check_arg(., "lambda") %>% check_equal(incorrect_msg = "Don't forget to perform a log transform with `lambda = 0`.", append = FALSE)
    }
    check_object(., "fit")
    
    check_code(., "summary(fit)", append = FALSE, fixed = TRUE, missing_msg = "Did you call `summary()` on `fit`?")
    
    check_object(., "d") %>% check_equal(incorrect_msg = "Did you assign the correct value to `d`? `summary(fit)` contains the information on the lag-1 differencing.", append = FALSE)
    check_object(., "D") %>% check_equal(incorrect_msg = "Did you assign the correct value to `D`? `summary(fit)` contains the information on the seasonal differencing.", append = FALSE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Did you pipe `fit` to `forecast()`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Are you looking 2 years ahead? `h02` contains monthly sales data.", append = FALSE)
    }
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of `forecast()` into `autoplot()`?", append = FALSE)
}

success_msg("Good job. `auto.arima()` is flexible enough to even work with seasonal time series!")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:2af34d230b
## Exploring auto.arima() options

The `auto.arima()` function needs to estimate a lot of different models, and various short-cuts are used to try to make the function as fast as possible. This can cause a model to be returned which does not actually have the smallest AICc value. To make `auto.arima()` work harder to find a good model, add the optional argument `stepwise = FALSE` to look at a much larger collection of models.

Here, you will try finding an ARIMA model for the pre-loaded `euretail` data, which contains quarterly retail trade in the Euro area from 1996-2011. Inspect it in the console before beginning this exercise.


*** =instructions

- Use the default options in `auto.arima()` to find an ARIMA model for `euretail` and save this to `fit1`.
- Use `auto.arima()` without a stepwise search to find an ARIMA model for `euretail` and save this to `fit2`.
- Run `summary()` for both `fit1` and `fit2` in your console, and use this to determine the better model. To 2 decimal places, what is its AICc value? Assign the number to `AICc`.
- Finally, using the better model based on AICc, plot its 2-year forecasts. Set `h` accordingly.

*** =hint

- The better model has a smaller AICc value. Also, in general, a model returned when `stepwise = FALSE` will never be worse than a model obtained with `stepwise = TRUE`.
- Use `stepwise = FALSE` as the second argument in `auto.arima()` to avoid using a stepwise search.
- Since the `euretail` data is quarterly, the correct `h` value to forecast 2 years ahead is 2 * 4.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Find an ARIMA model for euretail
fit1 <- ___

# Don't use a stepwise search
fit2 <- ___

# AICc of better model
AICc <- ___

# Compute 2-year forecasts from better model
___ %>% ___ %>% ___
```

*** =solution
```{r}
# Find an ARIMA model for euretail
fit1 <- auto.arima(euretail)

# Don't use a stepwise search
fit2 <- auto.arima(euretail, stepwise = FALSE)

# AICc of better model
AICc <- 68.39

# Compute 2-year forecasts from better model
fit2 %>% forecast(h = 8) %>% autoplot()
```

*** =sct
```{r}
msg <- "In your %s call to `auto.arima()`, did you fit a model to `euretail`?"

ex() %>% {
    check_error(.)
    
    check_function(., "auto.arima") %>% check_arg("y") %>% check_equal(incorrect_msg = sprintf(msg, "first"), append = FALSE)
    check_object(., "fit1")
    
    check_function(., "auto.arima", index = 2) %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg, "second"), append = FALSE)
        check_arg(., "stepwise") %>% check_equal(incorrect_msg = "In your second call to `auto.arima()`, don't use a `stepwise` search.", append = FALSE)
    }
    check_object(., "fit2")
    
    check_object(., "AICc") %>% check_equal(incorrect_msg = "Did you call `summary()` on `fit1` and `fit2`? Assign the lower **AICc** value of the two models to `AICc` (Remember to round off the value to two decimal places).", append = FALSE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Did you pipe the better model into `forecast()`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Are you plotting the 2 years forecast? Remember, the `euretail` data is quarterly.", append = FALSE)
    }
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of `forecast()` into `autoplot()`?", append = FALSE)
}

success_msg("Great! `auto.arima()` has a wealth of options that are worth exploring.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:2e33c62db0
## Comparing auto.arima() and ets() on seasonal data

What happens when you want to create training and test sets for data that is more frequent than yearly? If needed, you can use a vector in form `c(year, period)` for the `start` and/or `end` keywords in the `window()` function. You must also ensure that you're using the appropriate values of `h` in forecasting functions. Recall that `h` should be equal to the length of the data that makes up your test set.

For example, if your data spans 15 years, your training set consists of the first 10 years, and you intend to forecast the last 5 years of data, you would use `h = 12 * 5` not `h = 5` because your test set would include 60 monthly observations. If instead your training set consists of the first 9.5 years and you want forecast the last 5.5 years, you would use `h = 66` to account for the extra 6 months.

In the final exercise for this chapter, you will compare seasonal ARIMA and ETS models applied to the quarterly cement production data `qcement`. Because the series is very long, you can afford to use a training and test set rather than time series cross-validation. This is much faster.

The `qcement` data is available to use in your workspace.

*** =instructions

- Create a training set called `train` consisting of 20 years of `qcement` data beginning in the year 1988 and ending at the last quarter of 2007; you must use a vector for `end`. The remaining data is your test set.
- Fit ARIMA and ETS models to the training data and save these to `fit1` and `fit2`, respectively.
- Just as you have done with previous exercises, check that both models have white noise residuals.
- Produce forecasts for the remaining data from both models as `fc1` and `fc2`, respectively. Set `h` to the number of total quarters in `qcement` minus the ones in `train`. Be careful- the last observation in `qcement` is *not* the final quarter of the year!
- Using the `accuracy()` function, find the better model based on the RMSE value, and save it as `bettermodel`.

*** =hint

- In `window()`, `start` is equal to the starting year of the `qcement` data, 1988, and `end` is in the format `c(YYYY, Q)`. Use `head()` and `tail()` on `qcement` if you're not sure what these dates are.
- The last data point in `qcement` is in the first quarter of 2014, and the last data point in the training set is in the fourth quarter of 2007. Therefore, `h` in `forecast()` is equal to $1 + (4 * (2013 - 2007))$.
- You do not need to set up a test set. Just pass the whole of `qcement` as the test set to `accuracy()` and it will find the relevant part to use in comparing with the forecasts.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Use 20 years of the qcement data beginning in 1988
train <- window(___, start = ___, end = ___)

# Fit an ARIMA and an ETS model to the training data
fit1 <- ___
fit2 <- ___

# Check that both models have white noise residuals
___
___

# Produce forecasts for each model
fc1 <- forecast(___, h = ___)
fc2 <- forecast(___, h = ___)

# Use accuracy() to find better model based on RMSE
accuracy(___, ___)
accuracy(___, ___)
bettermodel <- ___
```

*** =solution
```{r}
# Use 20 years of the qcement data beginning in 1988
train <- window(qcement, start = 1988, end = c(2007, 4))

# Fit an ARIMA and an ETS model to the training data
fit1 <- auto.arima(train)
fit2 <- ets(train)

# Check that both models have white noise residuals
checkresiduals(fit1)
checkresiduals(fit2)

# Produce forecasts for each model
fc1 <- forecast(fit1, h = 25)
fc2 <- forecast(fit2, h = 25)

# Use accuracy() to find best model based on RMSE
accuracy(fc1, qcement)
accuracy(fc2, qcement)
bettermodel <- fc2
```

*** =sct
```{r}
msg1 <- "The first argument to `accuracy()` should be the forecast object, `%s`."
msg2 <- "The second argument to `accuracy()` should be the `qcement` series."

ex() %>% {
    check_error(.)
    
    check_function(., "window") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you call `window()` on `qcement`?", append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = "Did you set the `end` argument to the last quarter of 2007? It should be of the form `c(year, period)`.", append = FALSE)
    }
}

check_or(
    ex() %>% check_code("start = 1988", append = FALSE, fixed = TRUE, missing_msg = "Did you set the `start` argument to the first quarter of 1988?"), 
    ex() %>% check_code("start = c(1988, 1)", append = FALSE, fixed = TRUE, missing_msg = "Did you set the `start` argument to the first quarter of 1988?")
)

ex() %>% {
    check_object(., "train")
    check_function(., "auto.arima") %>% check_arg("y") %>% check_equal(incorrect_msg = "Are you using auto.arima() to fit an ARIMA to `train`?", append = FALSE)
    check_object(., "fit1")
    check_function(., "ets") %>% check_arg("y") %>% check_equal(incorrect_msg = "Are you using ets() to fit an ETS to `train`?", append = FALSE)
    check_object(., "fit2")
    
    check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you check the residuals of `fit1`?", append = FALSE)
    check_function(., "checkresiduals", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you check the residuals of `fit2`?", append = FALSE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit1`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = , append = FALSE)
    }
    check_object(., "fc1")
    
    check_function(., "forecast", index = 2) %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit2`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = , append = FALSE)
    }
    check_object(., "fc2")
    
    check_function(., "accuracy") %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg1, "fit1"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = msg2, append = FALSE)
    }
    
    check_function(., "accuracy", index = 2) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg1, "fit2"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = msg2, append = FALSE)
    }
    
    check_object(., "bettermodel") %>% check_equal(incorrect_msg = "Did you assign the better model based on the RMSE value to `bettermodel`?", append = FALSE, eval = FALSE)
}

success_msg("Excellent! Looks like the ETS model did better here.")
```
