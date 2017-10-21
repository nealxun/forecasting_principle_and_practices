---
title: Exponential smoothing
description: >-
  Forecasts produced using exponential smoothing methods are weighted averages
  of past observations, with the weights decaying exponentially as the
  observations get older. In other words, the more recent the observation, the
  higher the associated weight. This framework generates reliable forecasts
  quickly and for a wide range of time series, which is a great advantage and of
  major importance to applications in business.
attachments : 
  slides_link : https://s3.amazonaws.com/assets.datacamp.com/production/course_3002/slides/ch3.pdf
  
--- type:VideoExercise lang:r xp:50 skills:1 key:c3cf396259
## Exponentially weighted forecasts

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch3_1.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:d36f736ad1
## Simple exponential smoothing

The `ses()` function produces forecasts obtained using **simple exponential smoothing (SES)**. The parameters are estimated using least squares estimation. All you need to specify is the time series and the forecast horizon; the default forecast time is  `h = 10` years.

```
> args(ses)
function (y, h = 10, ...)

> fc <- ses(oildata, h = 5)
> summary(fc)
```

You will also use `summary()` and `fitted()`, along with `autolayer()` for the first time, which is like `autoplot()` but it adds a "layer" to a plot rather than creating a new plot.

Here, you will apply these functions to `marathon`, the annual winning times in the Boston marathon from 1897-2016. The data are available in your workspace.



*** =instructions

 - Use the `ses()` function to forecast the next 10 years of winning times.
 - Use the `summary()` function to see the model parameters and other information.
 - Use the `autoplot()` function to plot the forecasts.
 - Add the one-step forecasts for the training data, or fitted values, to the plot using `fitted()` and `autolayer()`.


*** =hint

`fitted(fc)` will create a time series of the one-step forecasts, so, `autolayer(fitted(fc))` will add the fitted values to a plot.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Use ses() to forecast the next 10 years of winning times
fc <- ___(___, h = ___)

# Use summary() to see the model parameters
___

# Use autoplot() to plot the forecasts
___

# Add the one-step forecasts for the training data to the plot
autoplot(___) + autolayer(fitted(___))
```

*** =solution
```{r}
# Use ses() to forecast the next 10 years of winning times
fc <- ses(marathon, h = 10)

# Use summary() to see the model parameters
summary(fc)

# Use autoplot() to plot the forecasts
autoplot(fc)

# Add the one-step forecasts for the training data to the plot
autoplot(fc) + autolayer(fitted(fc))
```

*** =sct
```{r}
msg <- "Did you call `%s()` on `%s`?"

ex() %>% {
  check_error(.)
  check_function(., "ses") %>% {
    check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg, "ses", "marathon"), append = FALSE)
    check_arg(., "h") %>% check_equal(incorrect_msg = "Did you set `h` correctly? You need to forecast for the next 10 years.", append = FALSE)
  } 
  check_expr(., "fc$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you call `ses()` on `marathon` and assign the result to `fc`?", append = FALSE)
  
  check_code(., "summary(fc)", fixed = TRUE, missing_msg = sprintf(msg, "summary", "fc"), append = FALSE)
  
  check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "fc"), eval = FALSE, append = FALSE)
  
  check_code(., "autoplot(fc) + autolayer(fitted(fc))", fixed = TRUE, missing_msg = "Did you add the one-step forecasts for the training data to the plot?", append = FALSE)
}

success_msg("Good job. You just forecasted using simple exponential smoothing.")

```

--- type:NormalExercise lang:r xp:100 skills:1 key:db35c3e68a
## SES vs naive

In this exercise, you will apply your knowledge of training and test sets, the `subset.ts()` function, and the `accuracy()` function, all of which you learned in Chapter 2, to compare SES and naive forecasts for the `marathon` data.

You did something very similar to compare the naive and mean forecasts in an earlier exercise "Evaluating forecast accuracy of non-seasonal methods".

Let's review the process:

1. First, import and load your data. Determine how much of your data you want to allocate to training, and how much to testing; the sets should *not* overlap.
2. Subset the data to create a training set, which you will use as an argument in your forecasting function(s). Optionally, you can also create a test set to use later.
3. Compute forecasts of the training set using whichever forecasting function(s) you choose, and set `h` equal to the number of values you want to forecast, which is also the length of the test set.
4. To view the results, use the `accuracy()` function with the forecast as the first argument and original data (or test set) as the second. 
5. Pick a measure in the output, such as RMSE or MAE, to evaluate the forecast(s); a smaller error indicates higher accuracy.

The `marathon` data is loaded into your workspace.


*** =instructions

 - Using `subset.ts()`, create a training set for `marathon` comprising all but the last 20 years of the data which you will reserve for testing.
 - Compute the SES and naive forecasts of this training set and save them to `fcses` and `fcnaive`, respectively.
 - Calculate forecast accuracy measures of the two sets of forecasts using the `accuracy()` function in your console.
 - Assign the best forecasts (either `fcses` or `fcnaive`) based on RMSE to `fcbest`.

*** =hint

- The last index of your training set is the length of the `marathon` data set minus 20. Set this equal to `end`.
- The first argument of your SES naive forecasting functions is the training data `train`, and the second is `h = 20`.
- Determine the best forecasts based on a smaller RMSE value for the test set, not the training set.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Create a training set using subset.ts()
train <- ___(___, end = length(marathon) - ___)

# Compute SES and naive forecasts, save to fcses and fcnaive
fcses <- ses(___, h = ___)
fcnaive <- naive(___, h = ___)

# Calculate forecast accuracy measures
accuracy(___, ___)
accuracy(___, ___)

# Save the best forecasts as fcbest
fcbest <- ___
```

*** =solution
```{r}
# Create a training set using subset.ts()
train <- subset.ts(marathon, end = length(marathon) - 20)

# Compute SES and naive forecasts, save to fcses and fcnaive
fcses <- ses(train, h = 20)
fcnaive <- naive(train, h = 20)

# Calculate forecast accuracy measures
accuracy(fcses, marathon)
accuracy(fcnaive, marathon)

# Save the best forecasts as fcbest
fcbest <- fcnaive
```

*** =sct
```{r}
msg <- "Did you call `%s()` on `train` and assign the output to `%s`?"

ex () %>% {
    check_error(.)
    check_function(., "subset.ts") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Are you subsetting the `marathon` data set?", append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = "Did you choose all but the last 20 years of data to train on?", append = FALSE)
    }
    check_object(., "train") %>% check_equal(incorrect_msg = "Did you call `subset.ts()` on `marathon` and assign the result to `train`?", append = FALSE)
    
    check_function(., "ses") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Did you compute `ses()` forecast on the `train` data set?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Did you specify `h`? You should forecast the next 20 years?", append = FALSE)
    }
    check_expr(., "fcses$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg, "ses", "fcses"), append = FALSE)
    
    check_function(., "naive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Did you compute `naive()` forecast on the `train` data set.", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Did you specify `h`? You should forecast the next 20 years.", append = FALSE)
    }
    check_expr(., "fcnaive$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg, "naive", "fcnaive"), append = FALSE)
    
    check_function(., "accuracy") %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = "Are you computing the accuracy for `fcses`?", append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you specify `marathon` as the second argument to `accuracy()`?", append = FALSE)
    }
    
    check_function(., "accuracy", index = 2) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = "Are you computing the accuracy for `fcnaive`?", append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you specify `marathon` as the second argument to `accuracy()`?", append = FALSE)
    }
    
    check_expr(., "fcbest$mean") %>% check_result() %>% check_equal(incorrect_msg = "Are you sure you chose the better of the two forecasts and assign it to `fcbest`?", append = FALSE)
}

success_msg("More complex models aren't always better!")

```

--- type:VideoExercise lang:r xp:50 skills:1 key:4f01a84caa
## Exponential smoothing methods with trend

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch3_2.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:ea39871a6d
## Holt's trend methods

Holt's local trend method is implemented in the `holt()` function:

```
> holt(y, h = 10, ...)
```

Here, you will apply it to the `austa` series, which contains annual counts of international visitors to Australia from 1980-2015 (in millions). The data has been pre-loaded into your workspace.

*** =instructions

- Produce 10 year forecasts of `austa` using Holt's method. Set `h` accordingly.
- Use the `summary()` function to view the model parameters and other information.
- Plot your forecasts using the standard time plotting function.
- Use `checkresiduals()` to see if the residuals resemble white noise.

*** =hint

With a short time series like this, it should be easy to find a model that has white noise residuals. A more important task is finding a model that gives good forecasts.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Produce 10 year forecasts of austa using holt()
fcholt <- ___

# Look at fitted model using summary()
___

# Plot the forecasts
___

# Check that the residuals look like white noise
___
```

*** =solution
```{r}
# Produce 10 year forecasts of austa using holt()
fcholt <- holt(austa, h = 10)

# Look at fitted model using summary()
summary(fcholt)

# Plot the forecasts
autoplot(fcholt)

# Check that the residuals look like white noise
checkresiduals(fcholt)
```

*** =sct
```{r}
msg <- "Did you call `%s()` on `%s`?"

ex() %>% {
  check_error(.)
  
  check_function(., "holt") %>% {
    check_arg(., "y") %>% check_equal(incorrect_msg = "Did you use `holt()` to compute forecasts of the `austa` data set?", append = FALSE)
    check_arg(., "h") %>% check_equal(incorrect_msg = "Did you set `h` correctly? You should forecast the next 10 years.", append = FALSE)
  } 
  check_expr(., "fcholt$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you produce 10 year forecasts of `austa` using Holt's method and assign the result to `fcholt`?", append = FALSE)
  
  check_code(., "summary(fcholt)", fixed = TRUE, missing_msg = sprintf(msg, "summary", "fcholt"), append = FALSE)
  
  check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "fcholt"), append = FALSE, eval = FALSE)
  
  check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "checkresiduals", "fcholt"), append = FALSE, eval = FALSE)
  
}

success_msg("Great! Do you think the Holt's trend model gives a good forecast?")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:44521a0d99
## Exponential smoothing methods with trend and seasonality

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch3_3.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:f9c54b1a71
## Holt-Winters with monthly data


In the video, you learned that the `hw()` function produces forecasts using the Holt-Winters method specific to whatever you set equal to the `seasonal` argument:

```
fc1 <- hw(aust, seasonal = "additive")
fc2 <- hw(aust, seasonal = "multiplicative")
```

Here, you will apply `hw()` to `a10`, the monthly sales of anti-diabetic drugs in Australia from 1991 to 2008. The data are available in your workspace.


*** =instructions

- Produce a time plot of the `a10` data.
- Produce forecasts for the next 3 years using `hw()` with multiplicative seasonality and save this to `fc`.
- Do the residuals look like white noise? Check them using the appropriate function and set `whitenoise` to either `TRUE` or `FALSE`.
- Plot a time plot of the forecasts.

*** =hint

Just because the residuals fail the white noise test doesn't mean the forecasts will be bad. Most likely, the prediction intervals will be inaccurate but the point forecasts will still be ok.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the data
___

# Produce 3 year forecasts
fc <- hw(___, seasonal = ___, h = ___)

# Check if residuals look like white noise
___
whitenoise <- ___

# Plot forecasts
___
```

*** =solution
```{r}
# Plot the data
autoplot(a10)

# Produce 3 year forecasts
fc <- hw(a10, seasonal = "multiplicative", h = 36)

# Check if residuals look like white noise
checkresiduals(fc)
whitenoise <- FALSE

# Plot forecasts
autoplot(fc)
```

*** =sct
```{r}
msg <- "Did you call `%s()` on `%s`?"

ex() %>% {
  check_error(.)
  
  check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "a10"), append = FALSE)
  
  check_function(., "hw") %>% {
    check_arg(., "y") %>% check_equal(append = FALSE, incorrect_msg = "Did you compute Holt-Winters forecasts on the `a10` data set?")
    check_arg(., "seasonal") %>% check_equal(append = FALSE, incorrect_msg = 'Did you produce forecasts for the next 3 years with `"multiplicative"` seasonality')
    check_arg(., "h") %>% check_equal(append = FALSE, incorrect_msg = "Did you use the correct `h` value? You should forecast the next 3 years (in months).")
  }
  check_expr(., "fc$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you produce forecasts for the next 3 years using `hw()` with multiplicative seasonality and save this to `fc`?", append = FALSE)
  
  check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "checkresiduals", "fc"), append = FALSE, eval = FALSE)
  check_object(., "whitenoise") %>% check_equal(incorrect_msg = "Take another look at the results of the Ljung-Box test. Is the p-value significant (below 0.05) or insignificant (above 0.05)?", append = FALSE)
  
  check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "fc"), append = FALSE, eval = FALSE)
}

success_msg("Correct. The forecasts might still provide useful information even with residuals that fail the white noise test.")

```

--- type:NormalExercise lang:r xp:100 skills:1 key:a4de4bbac9
## Holt-Winters method with daily data

The Holt-Winters method can also be used for daily type of data, where the seasonal pattern is of length 7, and the appropriate unit of time for `h` is in days.

Here, you will compare an additive Holt-Winters method and a seasonal `naive()` method for the `hyndsight` data, which contains the daily pageviews on the Hyndsight blog for one year starting April 30, 2014. The data are available in your workspace.

*** =instructions

- Using `subset.ts()`, set up a training set where the last 4 weeks of the available data in `hyndsight` have been omitted.
- Produce forecasts for these last 4 weeks using `hw()` and additive seasonality applied to the training data. Assign this to `fchw`.
- Produce seasonal naive forecasts for the same period. Use the appropriate function, introduced in a previous chapter, and assign this to `fcsn`.
- Which is the better of the two forecasts based on RMSE? Use the `accuracy()` function to determine this.
- Produce time plots of these forecasts.

*** =hint

- For `subset.ts()`, set the `end` argument to the `length()` of the data minus the number of *days*, not weeks, that you want to omit.
- Remember to compare the RMSE based on the test set, not the training set. Generally, better forecasts have smaller error.
- If you try running `checkresiduals()` on the best model, it fails badly because the residuals are not white noise or normally distributed. This suggests we should be able to do better than either of these models. 

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Create training data with subset()
train <- subset.ts(___, end = ___)

# Holt-Winters additive forecasts as fchw
fchw <- hw(___, seasonal = ___, h = ___)

# Seasonal naive forecasts as fcsn
fcsn <- ___

# Find better forecasts with accuracy()
accuracy(___, ___)
accuracy(___, ___)

# Plot the better forecasts
autoplot(___)
```

*** =solution
```{r}
# Create training data with subset()
train <- subset.ts(hyndsight, end = length(hyndsight) - 28)

# Holt-Winters additive forecasts as fchw
fchw <- hw(train, seasonal = "additive", h = 28)

# Seasonal naive forecasts as fcsn
fcsn <- snaive(train, h = 28)

# Find better forecasts with accuracy()
accuracy(fchw, hyndsight)
accuracy(fcsn, hyndsight)

# Plot the better forecasts
autoplot(fchw)
```

*** =sct
```{r}
msg1 <- "Did you call `accuracy()` on `%s`?"
msg2 <- "In your %s call to `accuray()`, did you specify the second argument as `hyndsight`?"
msg3 <- "Did you call `%s()` on `train` and assign the output to `%s`?"

ex() %>% {
    check_error(.)
    
    check_function(., "subset.ts") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Are you correctly subsetting the `hyndsight` data set?", append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = "Are you using the correct end date? Set the `end` argument to the `length()` of the data minus the number of *days*, not weeks, that you want to omit.", append = FALSE)
    }
    check_object(., "train") %>% check_equal(incorrect_msg = "Did you call `subset.ts()` on `hyndsight` and assign the result to `train`?", append = FALSE)
    
    check_function(., "hw") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Compute Holt-Winters forecasts on the `train` data set.", append = FALSE)
        check_arg(., "seasonal") %>% check_equal(incorrect_msg = "You should be using `additive` seasonality.", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should forecast the next 4 weeks. Set `h` to the equivalent number of days.", append = FALSE)
    }
    check_expr(., "fchw$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg3, "hw", "fchw"), append = FALSE)
    
    check_function(., "snaive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Compute snaive forecasts on the `train` data set.", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should forecast the next 4 weeks. Set `h` to the equivalent number of days.", append = FALSE)
    }
    check_expr(., "fcsn$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg3, "snaive", "fcsn"), append = FALSE)
    
    check_function(., "accuracy") %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg1, "fchw"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg2, "first"), append = FALSE)
    }
    
    check_function(., "accuracy", index = 2) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg1, "fcsn"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg2, "second"), append = FALSE)
    }
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you plot the better of the two forecasts based on RMSE?", append = FALSE, eval = FALSE)
}

success_msg("Great! Could we do better than both of these models?")

```

--- type:VideoExercise lang:r xp:50 skills:1 key:7582f98a0e
## State space models for exponential smoothing

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch3_4.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:b15b054b40
## Automatic forecasting with exponential smoothing

The namesake function for finding **errors, trend, and seasonality (ETS)** provides a completely automatic way of producing forecasts for a wide range of time series.

You will now test it on two series, `austa` and `hyndsight`, that you have previously looked at in this chapter. Both have been pre-loaded into your workspace.

*** =instructions

- Using `ets()`, fit an ETS model to `austa` and save this to `fitaus`.
- Using the appropriate function, check the residuals from this model.
- Plot forecasts from this model by using `forecast()` and `autoplot()` together. 
- Repeat these three steps for the `hyndsight` data and save this model to `fiths`.
- Which model(s) fails the Ljung-Box test? Assign `fitausfail` and `fithsfail` to either `TRUE` (if the test fails) or `FALSE` (if the test passes).

*** =hint

Remember, a model passes the Ljung-Box test when the p-value is greater than 0.05. Observe the results of this test by running the `checkresiduals()` function for each series in your console.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Fit ETS model to austa in fitaus
___ <- ___(___)

# Check residuals
___(___)

# Plot forecasts
___(___(___))

# Repeat for hyndsight data in fiths
fiths <- ___(___)
___(___)
___(___(___))

# Which model(s) fails test? (TRUE or FALSE)
fitausfail <- ___
fithsfail <- ___
```

*** =solution
```{r}
# Fit ETS model to austa in fitaus
fitaus <- ets(austa)

# Check residuals
checkresiduals(fitaus)

# Plot forecasts
autoplot(forecast(fitaus))

# Repeat for hyndsight data in fiths
fiths <- ets(hyndsight)
checkresiduals(fiths)
autoplot(forecast(fiths))

# Which model(s) fails test? (TRUE or FALSE)
fitausfail <- FALSE
fithsfail <- TRUE
```

*** =sct
```{r}
msg1 <- "Are you fitting an `ets()` model to `%s`?"
msg2 <- "Did you look at the residuals of `%s`?"
msg3 <- "Did you call `autoplot()` on `forecast(%s)`?"
msg4 <- "Did `%s` pass the Ljung-Box test?"

ex() %>% {
    check_error(.)
    
    check_function(., "ets") %>% check_arg("y") %>% check_equal(incorrect_msg = sprintf(msg1, "austa"), append = FALSE)
    check_expr(., "fitaus$call") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of your first `ets()` call to `fitaus`?", append = FALSE)
    
    check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg2, "fitaus"), append = FALSE)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg3, "fitaus"), append = FALSE)
    
    check_function(., "ets", index = 2) %>% check_arg("y") %>% check_equal(incorrect_msg = sprintf(msg1, "hyndsight"), append = FALSE)
    check_expr(., "fiths$call") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of your second `ets()` call to `fiths`?", append = FALSE)
    
    check_function(., "checkresiduals", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg2, "fiths"), append = FALSE)
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg3, "fitaus"), append = FALSE)
    
    check_object(., "fitausfail") %>% check_equal(incorrect_msg = sprintf(msg4, "fitausfail"), append = FALSE)
    check_object(., "fithsfail") %>% check_equal(incorrect_msg = sprintf(msg4, "fithsfail"), append = FALSE)
}

success_msg("Great! The automatic forecasting is great for getting quick results.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:911da14385
## ETS vs seasonal naive

Here, you will compare ETS forecasts against seasonal naive forecasting for 20 years of `cement`, which contains quarterly cement production using time series cross-validation for 4 steps ahead. Because this takes a while to run, a shortened version of the `cement` series will be available in your workspace.

The second argument for `tsCV()` must return a forecast object, so you need a function to fit a model and return forecasts. Recall:

```
> args(tsCV)
function (y, forecastfunction, h = 1, ...)
```

In this exercise you will use an existing forecasting function as well as one that has been created for you. Remember, sometimes simple methods work better than more sophisticated methods!

*** =instructions

- A function to return ETS forecasts, `fets()`, has been written for you.
- Apply `tsCV()` for both ETS and seasonal naive methods to the `cement` data for a forecast horizon of 4. Use the newly created `fets` and the existing `snaive` functions as your forecast function argument for `e1` and `e2`, respectively.
- Compute the MSE of the resulting 4-step errors and remove missing values. The expressions for calculating MSE have been provided for you, but the second optional arguments have not (you've used them before).
- Save the best MSE as `bestmse`. You can simply copy the entire line of code that generates the best MSE from the previous instruction.

*** =hint

- The first argument of `tsCV()` is the `cement` data series, the second is the function that will fit the model (either `fets()` or `snaive()`), and the third is the appropriate `h` value of 4.
- Because the errors have some missing values, set the optional `na.rm` argument in `mean()` to `TRUE` when computing MSE.
- After filling in the `mean()` functions, run them in your console. The expression with the smaller value has a smaller error and is therefore the better option.

*** =pre_exercise_code
```{r}
library(fpp2)
cement <- subset(qcement, start=length(qcement) - 80)
```

*** =sample_code
```{r}
# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}

# Apply tsCV() for both methods
e1 <- tsCV(___, ___, h = ___)
e2 <- tsCV(___, ___, h = ___)

# Compute MSE of resulting errors (watch out for missing values)
mean(e1^2, ___)
mean(e2^2, ___)

# Copy the best forecast MSE
bestmse <- ___
```

*** =solution
```{r}
# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}

# Apply tsCV() for both methods
e1 <- tsCV(cement, fets, h = 4)
e2 <- tsCV(cement, snaive, h = 4)

# Compute MSE of resulting errors (watch out for missing values)
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Copy the best forecast MSE
bestmse <- mean(e2^2, na.rm = TRUE)
```

*** =sct
```{r}
msg1 <- "In your %s `tsCV()` call, are you calculating cross validation on `cement`?"
msg2 <- "In your %s `tsCV()` call, did you set the second argument to `%s`?"
msg3 <- "In your %s `tsCV()` call, is your forecast horizon `h` set to `4`?"
msg4 <- "Did you take the mean of `%s`?"
msg5 <- "Did you remove missing values when taking the mean of `%s`? Set the second argument `na.rm` equal to `TRUE`."

ex() %>% {
    check_error(.)
    
    check_function(., "tsCV") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg1, "first"), append = FALSE)
        check_arg(., "forecastfunction") %>% check_equal(incorrect_msg = sprintf(msg2, "first", "fets"), append = FALSE)
        check_arg(., "h")
    }
    check_object(., "e1") %>% check_equal(incorrect_msg = sprintf(msg3, "first"), append = FALSE)
    
    check_function(., "tsCV", index = 2) %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg1, "second"), append = FALSE)
        check_arg(., "forecastfunction") %>% check_equal(incorrect_msg = sprintf(msg2, "second", "snaive"), append = FALSE)
        check_arg(., "h")
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
    check_expr(., "round(bestmse, 3)") %>% check_result() %>% check_equal(incorrect_msg = "Did you choose the better MSE? `bestmse` should hold the MSE for that model.", append = FALSE)
}

success_msg("Nice! Complex isn't always better.")

```

--- type:MultipleChoiceExercise lang:r xp:50 skills:1 key:fc781f933b
## Match the models to the time series

Look at this series of plots and guess which is the appropriate ETS model for each plot. Recall from the video:

```
Trend = {N,A,Ad}
Seasonal = {N,A,M}
Error = {A,M}
```

The simplest approach is to look for which time series and models are seasonal.

*** =instructions

Match the plots to the appropriate ETS model.

 - A. ETS(M,N,M)  B. ETS(A,A,N)  C. ETS(M,M,N)  D. ETS(M,Ad,M)
 - A. ETS(M,N,N)  B. ETS(A,N,A)  C. ETS(M,A,N)  D. ETS(M,A,M)
 - A. ETS(M,A,M)  B. ETS(M,A,N)  C. ETS(M,M,M)  D. ETS(M,Ad,N)
 - A. ETS(M,N,M)  B. ETS(A,A,N)  C. ETS(A,A,A)  D. ETS(M,Ad,N)

*** =hint

 - The simplest approach is to look at which time series and which models are seasonal.
 - Remember, in the ETS(X,Y,Z) notation, X is the error, Y is the trend and Z is the seasonal component.

*** =pre_exercise_code
```{r}
library(fpp2)
p1 <- autoplot(qcement) + xlab("Year") + ylab("million tonnes") + ggtitle("A. Quarterly cement production")
p2 <- autoplot(austa) + xlab("Year") + ylab("million people") + ggtitle("B. Annual international visitors to Australia")
p3 <- autoplot(wmurders) + xlab("Year") + ylab("murder rate per 100,000 people") + ggtitle("C. Annual female murder rate (USA)")
p4 <- autoplot(h02) + xlab("Year") + ylab("million scripts") + ggtitle("D. Monthly cortecosteroid drug sales")
gridExtra::grid.arrange(p1,p2,p3,p4, nrow=2)
```

*** =sct
```{r}
msg1 = "Well done."
msg2 = "No. A is clearly seasonal, and B is clearly non-seasonal "
msg3 = "No. D is clearly seasonal."
msg4 = "No. D is clearly seasonal, while C is non-seasonal."
test_mc(correct = 1, feedback_msgs = c(msg1,msg2,msg3,msg4))
# General
test_error()
success_msg("Well spotted.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:226e6ebb25
## When does ETS fail?

Computing the ETS does not work well for all series. 

Here, you will observe why it does not work well for the annual Canadian lynx population available in your workspace as `lynx`.


*** =instructions

- Plot the `lynx` series using the standard plotting function and note the cyclic behaviour.
- Use `ets()` to model the `lynx` series, and assign this to `fit`.
- Use `summary()` to look at the selected model and parameters.
- Plot forecasts for the next 20 years using the pipe operator. Note that you only need to specify `h` for one particular function.

*** =hint

- ETS models cannot handle cyclic data.
- You must use the pipe operator to pass `fit()` to `forecast()` to `autoplot()`.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the lynx series
___

# Use ets() to model the lynx series
fit <- ___

# Use summary() to look at model and parameters
___

# Plot 20-year forecasts of the lynx series
fit %>% ___ %>% ___
```

*** =solution
```{r}
# Plot the lynx series
autoplot(lynx)

# Use ets() to model the lynx series
fit <- ets(lynx)

# Use summary() to look at model and parameters
summary(fit)

# Plot 20-year forecasts of the lynx series
fit %>% forecast(h = 20) %>% autoplot()
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on `lynx`?", append = FALSE)
    check_function(., "ets") %>% check_arg("y") %>% check_equal(incorrect_msg = "Did you call `ets()` on `lynx`?", append = FALSE)
    check_code(., "summary(fit)", missing_msg = "Did you call `summary()` on `fit`?", append = FALSE, fixed = TRUE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Did you pipe `fit` to `forecast()`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Are you looking forward 20 years? Set `h` accordingly.", append = FALSE)
    }
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the output of `forecast()` into `autoplot()`?", append = FALSE)
    
}

success_msg("It's important to realize that ETS doesn't work for all cases.")
```
