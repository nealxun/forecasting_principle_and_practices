---
title: Advanced methods
description: >-
  The time series models in the previous chapters work well for many time
  series, but they are often not good for weekly or hourly data, and they do not
  allow for the inclusion of other information such as the effects of holidays,
  competitor activity, changes in the law, etc. In this chapter, you will look at some
  methods that handle more complicated seasonality, and you consider how to
  extend ARIMA models in order to allow other information to be included in the
  them.
attachments : 
  slides_link : https://s3.amazonaws.com/assets.datacamp.com/production/course_3002/slides/ch5.pdf

--- type:VideoExercise lang:r xp:50 skills:1 key:ec023763a8
## Dynamic regression

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch5_1.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:5e55aecf5d
## Forecasting sales allowing for advertising expenditure

Welcome to the last chapter of the course!

The `auto.arima()` function will fit a dynamic regression model with ARIMA errors. The only change to how you used it previously is that you will now use the `xreg` argument containing a matrix of regression variables. Here are some code snippets from the video:

```
> fit <- auto.arima(uschange[, "Consumption"],
                    xreg = uschange[, "Income"])

> # rep(x, times)
> fcast <- forecast(fit, xreg = rep(0.8, 8))
```

You can see that the data is set to the `Consumption` column of `uschange`, and the regression variable is the `Income` column. Furthermore, the `rep()` function in this case would replicate the value 0.8 exactly eight times for the matrix argument `xreg`.

In this exercise, you will model sales data regressed against advertising expenditure, with an ARMA error to account for any serial correlation in the regression errors. The data are available in your workspace as `advert` and comprise 24 months of sales and advertising expenditure for an automotive parts company. The plot shows sales vs advertising expenditure.

Think through everything you have learned so far in this course, inspect the `advert` data in your console, and read each instruction carefully to tackle this challenging exercise.

*** =instructions

- Plot the data in `advert`. The variables are on different scales, so use `facets = TRUE`.
- Fit a regression with ARIMA errors to `advert` by setting the first argument of `auto.arima()` to the `"sales"` column, second argument `xreg` to the `"advert"` column, and third argument `stationary` to `TRUE`.
- Check that the fitted model is a regression with AR(1) errors. What is the increase in sales for every unit increase in advertising? This coefficient is the third element in the `coefficients()` output.
- Forecast from the fitted model specifying the next 6 months of advertising expenditure as 10 units per month as `fc`. To repeat 10 six times, use the `rep()` function inside `xreg` like in the example code above.
- Plot the forecasts `fc` and fill in the provided code to add an x label `"Month"` and y label `"Sales"`.

*** =hint

- To index all rows and one column named `"col"` from an imaginary dataset `ds`, you would use `ds[, "col"]`.
- Use `coefficients(fit)` to get the coefficients from the model. Then use brackets to index the position of the coefficient you want, in this case, 3.
- You don't need to specify the forecast horizon `h` when you provide `forecast()` with an `xreg` argument.

*** =pre_exercise_code
```{r}
library(fpp2)
# Scatter plot of the variables plotted against each other
qplot(advert, sales, data=as.data.frame(advert)) + xlab("Advertising") + ylab("Sales")
```

*** =sample_code
```{r}
# Time plot of both variables
autoplot(___, ___)

# Fit ARIMA model
fit <- auto.arima(___[, ___], xreg = ___[, ___], stationary = ___)

# Check model. Increase in sales for each unit increase in advertising
salesincrease <- ___(___)[___]

# Forecast fit as fc
fc <- forecast(___, xreg = ___)

# Plot fc with x and y labels
autoplot(___) + xlab(___) + ylab(___)
```

*** =solution
```{r}
# Time plot of both variables
autoplot(advert, facets = TRUE)

# Fit ARIMA model
fit <- auto.arima(advert[, "sales"], xreg = advert[, "advert"], stationary = TRUE)

# Check model. Increase in sales for each unit increase in advertising
salesincrease <- coefficients(fit)[3]

# Forecast fit as fc
fc <- forecast(fit, xreg = rep(10, 6))

# Plot fc with x and y labels
autoplot(fc) + xlab("Month") + ylab("Sales")
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Did you call `autoplot()` on `advert`?", append = FALSE)
        check_arg(., "facets") %>% check_equal(incorrect_msg = "Did you turn faceting on?", append = FALSE)
    }
    
    check_function(., "auto.arima") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = 'You should be fitting a dynamic regression model with ARIMA errors to the `"sales"` column of `advert`.', append = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = 'The `"advert"` column should be used as the independent variable in the regression.', append = FALSE)
        check_arg(., "stationary") %>% check_equal(incorrect_msg = "Don't forget to set `stationary` to `TRUE`.", append = FALSE)
    }
    check_object(., "fit")
    
    check_object(., "salesincrease") %>% check_equal(incorrect_msg = "Did you call `coefficients()` on `fit`, extract the third element and assign the result to `salesincrease`?", append = FALSE)
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE, eval = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = "Make sure to forecast the next 6 months as 10 units per month.", append = FALSE)
    }
    check_object(., "fc")
    
    check_code(., 'autoplot(fc) + xlab("Month") + ylab("Sales")', fixed = TRUE, append = FALSE, missing_msg = 'Did you call `autoplot()` on `fc` and add the x and y labels as `"Month"` and `"Sales"`?')
}

success_msg("Great job. The dynamic regression allows you to include other outside information into your forecast.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:9599a5963d
## Forecasting electricity demand

You can also model daily electricity demand as a function of temperature. As you may have seen on your electric bill, more electricity is used on hot days due to air conditioning and on cold days due to heating.

In this exercise, you will fit a quadratic regression model with an ARMA error. One year of daily data are stored as `elec` including total daily demand, an indicator variable for workdays (a workday is represented with 1, and a non-workday is represented with 0), and daily maximum temperatures. Because there is weekly seasonality, the `frequency` has been set to 7.

Let's take a look at the first three rows:

```
> elec[1:3, ]
       Demand Temperature Workday
[1,] 168.2798        20.2       0
[2,] 183.0822        21.9       1
[3,] 184.5135        25.1       1
```

`elec` has been pre-loaded into your workspace.


*** =instructions

- Produce time plots of *only* the daily demand and maximum temperatures with facetting.
- Index `elec` accordingly to set up the matrix of regressors to include `MaxTemp` for the maximum temperatures, `MaxTempSq` which represents the squared value of the maximum temperature, and `Workday`, in that order. Clearly, the second argument of `cbind()` will require a simple mathematical operator.
- Fit a dynamic regression model of the demand column with ARIMA errors and call this `fit`.
- If the next day is a working day (indicator is 1) with maximum temperature forecast to be 20°C, what is the forecast demand? Fill out the appropriate values in `cbind()` for the `xreg` argument in `forecast()`.

*** =hint

- Use the `head()` function on the data to determine the names of the columns you want to index. They should go into the vector that you use to index `elec` in the first plot. as well. Don't forget to include `facets = TRUE`.
- In `cbind()`, you can extract the maximum temperatures with `elec[, "Temperature"]` for `MaxTemp`. Add a `^2` to square that value for `MaxTempSq`.
- If you wanted to forecast a non-working day (indicator is 0) with a maximum temperature of 15°C, you would use `xreg = cbind(15, 15^2, 0)`. Apply the same logic for the last part of the exercise.

*** =pre_exercise_code
```{r}
library(fpp2)
demand <- colSums(matrix(elecdemand[,"Demand"], nrow=48))
temp <- apply(matrix(elecdemand[,"Temperature"], nrow=48),2,max)
wday <- colMeans(matrix(elecdemand[,"WorkDay"], nrow=48))
qplot(temp, demand) + xlab("Temperature") + ylab("Demand")
elec <- ts(cbind(Demand=demand, Temperature=temp, Workday=wday), frequency=7)
```

*** =sample_code
```{r}
# Time plots of demand and temperatures
autoplot(elec[, c(___, ___)], facets = ___)

# Matrix of regressors
xreg <- cbind(MaxTemp = elec[, "Temperature"], 
              MaxTempSq = ___, 
              Workday = ___)

# Fit model
fit <- auto.arima(___, xreg = xreg)

# Forecast fit one day ahead
forecast(___, xreg = cbind(___, ___, ___))
```

*** =solution
```{r}
# Time plots of demand and temperatures
autoplot(elec[, c("Demand", "Temperature")], facets = TRUE)

# Matrix of regressors
xreg <- cbind(MaxTemp = elec[, "Temperature"], 
              MaxTempSq = elec[, "Temperature"]^2, 
              Workday = elec[, "Workday"])

# Fit model
fit <- auto.arima(elec[, "Demand"], xreg = xreg)

# Forecast fit one day ahead
forecast(fit, xreg = cbind(20, 20^2, 1))
```

*** =sct
```{r}
msg <- "Did you forecast for a working day (indicator is 1) with maximum temperature forecast of 20°C?"

ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` the `"Demand"` and `"Temperature"` columns?', append = FALSE)
        check_arg(., "facets") %>% check_equal(incorrect_msg = "Did you turn faceting on?", append = FALSE)
    }
}

check_correct({
    ex() %>% check_object(., "xreg") %>% check_equal()
}, {
    ex() %>% {
        check_function(., "cbind", append = FALSE, not_called_msg = 'Did you call `cbind()` to create the matrix `xreg`?')
        check_code(., 'MaxTemp = elec[, "Temperature"]', fixed = TRUE, append = FALSE, missing_msg = 'Did you correctly define the column `"MaxTemp"? It should be equal to the column `"Temperature"` from the matrix `elec`.')
        check_code(., 'MaxTempSq = elec[, "Temperature"]^2', fixed = TRUE, append = FALSE, missing_msg = 'Did you correctly define the column `"MaxTempSq"? It should be equal to the square of column `"Temperature"` from the matrix `elec`.')
        check_code(., 'Workday = elec[, "Workday"]', fixed = TRUE, append = FALSE, missing_msg = 'Did you correctly define the column `"Workday"? It should be equal to the column `"Workday"` from the matrix `elec`.')
    }
})

ex() %>% {
    
    check_function(., "auto.arima") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = 'Did you fit a dynamic regression model with ARIMA errors to the `"Demand"` column of `elec`?', append = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = "Did you set the argument `xreg` to the matrix `xreg` you created in the earlier step?", append = FALSE)
    }
    check_object(., "fit")
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE)
        check_arg(., "xreg", arg_not_specified_msg = "Did you specify the `xreg` argument? It should be equal to `cbind(___, ___, ___)`.", append = FALSE)
    }
}

check_or(
    ex() %>% check_code(., cbind(20, 20^2, 1), fixed = TRUE, append = FALSE, missing_msg = msg), 
    ex() %>% check_code(., cbind(20, 20*20, 1), fixed = TRUE, append = FALSE, missing_msg = msg), 
    ex() %>% check_code(., cbind(20, 400, 1), fixed = TRUE, append = FALSE, missing_msg = msg)
)

success_msg("Great job! Now you've seen how multiple independent variables can be included using matrices.")
```


--- type:VideoExercise lang:r xp:50 skills:1 key:c6d2ba1188
## Dynamic harmonic regression

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch5_2.master.m3u8


--- type:NormalExercise lang:r xp:100 skills:1 key:24d1704131
## Forecasting weekly data

With weekly data, it is difficult to handle seasonality using ETS or ARIMA models as the seasonal length is too large (approximately 52). Instead, you can use harmonic regression which uses sines and cosines to model the seasonality. 

The `fourier()` function makes it easy to generate the required harmonics. The higher the order ($K$), the more "wiggly" the seasonal pattern is allowed to be. With $K=1$, it is a simple sine curve. You can select the value of $K$ by minimizing the AICc value. As you saw in the video, `fourier()` takes in a required time series, required number of Fourier terms to generate, and optional number of rows it needs to forecast:

```
> # fourier(x, K, h = NULL)

> fit <- auto.arima(cafe, xreg = fourier(cafe, K = 6),
                    seasonal = FALSE, lambda = 0)
> fit %>%
    forecast(xreg = fourier(cafe, K = 6, h = 24)) %>%
    autoplot() + ylim(1.6, 5.1)
```

The pre-loaded `gasoline` data comprises weekly data on US finished motor gasoline products. In this exercise, you will fit a harmonic regression to this data set and forecast the next 3 years.

*** =instructions

- Set up an `xreg` matrix called `harmonics` using the `fourier()` method on `gasoline` with order $K=13$ which has been chosen to minimize the AICc.
- Fit a dynamic regression model to `fit`. Set `xreg` equal to `harmonics` and `seasonal` to `FALSE` because seasonality is handled by the regressors.
- Set up a new `xreg` matrix called `newharmonics` in a similar fashion, and then compute forecasts for the next three years as `fc`.
- Finally, plot the forecasts `fc`.

*** =hint

- The `gasoline` data is weekly, and you want to forecast the next three years. `h` is therefore equal to 3 * 52.
- You don't need to specify `h` again in the `forecast()` function as it can figure out what is required from `xreg`.
- Still confused? Type `?fourier` into the console to read through the documentation.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Set up harmonic regressors of order 13
harmonics <- fourier(___, K = ___)

# Fit regression model with ARIMA errors
fit <- auto.arima(___, xreg = ___, seasonal = ___)

# Forecasts next 3 years
newharmonics <- fourier(___, K = ___, h = ___)
fc <- forecast(___, xreg = ___)

# Plot forecasts fc
___
```

*** =solution
```{r}
# Set up harmonic regressors of order 13
harmonics <- fourier(gasoline, K = 13)

# Fit regression model with ARIMA errors
fit <- auto.arima(gasoline, xreg = harmonics, seasonal = FALSE)

# Forecasts next 3 years
newharmonics <- fourier(gasoline, K = 13, h = 156)
fc <- forecast(fit, xreg = newharmonics)

# Plot forecasts fc
autoplot(fc)
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "fourier") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you create harmonic regressors from `gasoline`?", append = FALSE)
        check_arg(., "K") %>% check_equal(incorrect_msg = "Use `K = 13` to minimize AICc.", append = FALSE)
    }
    check_object(., "harmonics") %>% check_equal()
    
    check_function(., "auto.arima") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = 'Did you fit a dynamic regression model with ARIMA errors to `gasoline`?', append = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = "Did you set the argument `xreg` to `harmonics`?", append = FALSE)
        check_arg(., "seasonal") %>% check_equal(incorrect_msg = "Did you set `seasonal = FALSE`?", append = FALSE)
    }
    check_object(., "fit")
    
    check_function(., "fourier", index = 2) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you create harmonic regressors from `gasoline`?", append = FALSE)
        check_arg(., "K") %>% check_equal(incorrect_msg = "Use `K = 13` to minimize AICc.", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Did you forecast the next 3 years (in weeks)?", append = FALSE)
    }
    check_object(., "newharmonics") %>% check_equal()
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE, eval = FALSE)
        check_arg(., "xreg", arg_not_specified_msg = "Make sure you forecast using `newharmonics`.", append = FALSE)
    }
    check_object(., "fc")
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` on `fc`?', append = FALSE)
}

success_msg("Great. The point predictions look to be a bit low.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:6a63b7e72a
## Harmonic regression for multiple seasonality

Harmonic regressions are also useful when time series have multiple seasonal patterns. For example, `taylor` contains half-hourly electricity demand in England and Wales over a few months in the year 2000. The seasonal periods are 48 (daily seasonality) and 7 x 48 = 336 (weekly seasonality). There is not enough data to consider annual seasonality. 

`auto.arima()` would take a long time to fit a long time series such as this one, so instead you will fit a standard regression model with Fourier terms using the `tslm()` function. This is very similar to `lm()` but is designed to handle time series. With multiple seasonality, you need to specify the order $K$ for each of the seasonal periods.

```
# The formula argument is a symbolic description
# of the model to be fitted

> args(tslm)
function (formula, ...)
```

`tslm()` is a newly introduced function, so you should be able to follow the pre-written code for the most part. The `taylor` data are loaded into your workspace.


*** =instructions

- Fit a harmonic regression called `fit` to `taylor` using order 10 for each type of seasonality.
- Forecast 20 working days ahead as `fc`. Remember that the data are half-hourly in order to set the correct value for `h`.
- Create a time plot of the forecasts.
- Check the residuals of your fitted model. As you can see, `auto.arima()` would have done a better job.

*** =hint

- `K` in `fourier()` in `data.frame()` is the same value as `K` in `fourier` in `tslm()`.
- The correct `h` value for forecasting 2 working days ahead on half-hourly data would be 2 * 48. Apply this same logic to forecast 20 working days ahead.
- The first argument of `fourier()` in this case is always the `taylor` data.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Fit a harmonic regression using order 10 for each type of seasonality
fit <- tslm(taylor ~ fourier(___, K = c(10, 10)))

# Forecast 20 working days ahead
fc <- forecast(___, newdata = data.frame(fourier(___, K = ___, h = ___)))

# Plot the forecasts
___

# Check the residuals of fit
___
```

*** =solution
```{r}
# Fit a harmonic regression using order 10 for each type of seasonality
fit <- tslm(taylor ~ fourier(taylor, K = c(10, 10)))

# Forecast 20 working days ahead
fc <- forecast(fit, newdata = data.frame(fourier(taylor, K = c(10, 10), h = 20 * 48)))

# Plot the forecasts
autoplot(fc)

# Check the residuals of fit
checkresiduals(fit)
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "tslm") %>% check_arg("formula")
    
    check_function(., "fourier") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you create harmonic regressors from `taylor`?", append = FALSE)
        check_arg(., "K") %>% check_equal(incorrect_msg = "Use `K = c(10, 10)` for the two types of seasonality.", append = FALSE)
    }
    check_object(., "fit") %>% check_equal()
    
    check_function(., "fourier", index = 2) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you create harmonic regressors from `taylor`?", append = FALSE)
        check_arg(., "K") %>% check_equal(incorrect_msg = "Use `K = c(10, 10)` for the two types of seasonality.", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "How many periods is 20 days with 48 points per day? Set `h` accordingly.", append = FALSE)
    }
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE, eval = FALSE)
        check_arg(., "newdata", arg_not_specified_msg = "Did you specify the `newdata` argument in your call to `forecast()`?", append = FALSE)
    }
    check_object(., "fc")
    
    check_code(., "autoplot(fc)", missing_msg = "Did you call `autoplot()` on `fc`?", append = FALSE, fixed = TRUE)
    
    check_code(., "checkresiduals(fit)", missing_msg = "Did you check the residuals of `fit`?", append = FALSE, fixed = TRUE)
}

success_msg("Nice job! The residuals from the fitted model fail the tests badly, yet the forecasts are quite good.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:570bca2794
## Forecasting call bookings

Another time series with multiple seasonal periods is `calls`, which contains 20 consecutive days of 5-minute call volume data for a large North American bank. There are 169 5-minute periods in a working day, and so the weekly seasonal frequency is 5 x 169 = 845. The weekly seasonality is relatively weak, so here you will just model daily seasonality. `calls` is pre-loaded into your workspace.

The residuals in this case still fail the white noise tests, but their autocorrelations are tiny, even though they are significant. This is because the series is so long. It is often unrealistic to have residuals that pass the tests for such long series. The effect of the remaining correlations on the forecasts will be negligible.


*** =instructions

- Plot the `calls` data to see the strong daily seasonality and weak weekly seasonality.
- Set up the `xreg` matrix using order 10 for daily seasonality and 0 for weekly seasonality.
- Fit a dynamic regression model called `fit` using `auto.arima()` with `seasonal = FALSE` and `stationary = TRUE`.
- Check the residuals of the fitted model.
- Create the forecasts for 10 working days ahead as `fc`, and then plot it. The exercise description should help you determine the proper value of `h`.

*** =hint

- In `xreg`, `K` is equal to a vector with one element per seasonality, `c(10, 0)`.
- 10 working days ahead means `h` should be equal to 10 * 169 (the number of 5-minute calls in a working day).


*** =pre_exercise_code
```{r}
library(fpp2)
calls <- window(fpp2::calls, start=30 - 169/845)
```

*** =sample_code
```{r}
# Plot the calls data
___

# Set up the xreg matrix
xreg <- fourier(___, K = ___)

# Fit a dynamic regression model
fit <- auto.arima(___, xreg = ___, ___, ___)

# Check the residuals
___

# Plot forecasts for 10 working days ahead
fc <- forecast(fit, xreg =  fourier(calls, c(10, 0), h = ___))
___
```

*** =solution
```{r}
# Plot the calls data
autoplot(calls)

# Set up the xreg matrix
xreg <- fourier(calls, K = c(10, 0))

# Fit a dynamic regression model
fit <- auto.arima(calls, xreg = xreg, seasonal = FALSE, stationary = TRUE)

# Check the residuals
checkresiduals(fit)

# Plot forecast for 10 working days ahead
fc <- forecast(fit, xreg = fourier(calls, c(10, 0), h = 1690))
autoplot(fc)
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` on `calls`?', append = FALSE)
    
    check_function(., "fourier") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you create harmonic regressors from `calls`?", append = FALSE)
        check_arg(., "K") %>% check_equal(incorrect_msg = "Use `K = c(10, 0)` for the two types of seasonality.", append = FALSE)
    }
    check_object(., "xreg")
    
    check_function(., "auto.arima") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "You should be modeling the `calls` series.", append = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = "Set `xreg` to the `xreg` matrix you created earlier.", append = FALSE, eval = FALSE)
        check_arg(., "seasonal") %>% check_equal(incorrect_msg = "Remember to turn `seasonal` off since the regression is handling it.", append = FALSE)
        check_arg(., "stationary") %>% check_equal(incorrect_msg = "Remember to turn `stationary` on.", append = FALSE)
    }
    check_object(., "fit")
    
    check_code(., "checkresiduals(fit)", missing_msg = "Did you check the residuals of `fit`?", append = FALSE, fixed = TRUE)
    
    check_function(., "fourier", index = 2) %>% {
        check_arg(., "x") %>% check_equal()
        check_arg(., "K") %>% check_equal()
        check_arg(., "h") %>% check_equal()
    }
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE, eval = FALSE)
        check_arg(., "xreg") %>% check_equal(incorrect_msg = "Did you use a call to `fourier()` and set it to `xreg`? It should be the same as `xreg` but with `h` equal to the double the weekly seasonal frequency specified in the exercise description.", append = FALSE)
    }
    check_object(., "fc")
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` on `fc`?', append = FALSE, eval = FALSE)
}

success_msg("Great! Now you've gotten a lot of experience using complex forecasting techniques.")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:471983099e
## TBATS models

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch5_3.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:ef8a5362a2
## TBATS models for electricity demand

As you saw in the video, a **TBATS model** is a special kind of time series model. It can be very slow to estimate, especially with multiple seasonal time series, so in this exercise you will try it on a simpler series to save time. Let's break down elements of a TBATS model in `TBATS(1, {0,0}, -, {<51.18,14>})`, one of the graph titles from the video:

| Component       | Meaning                           |
| --------------- | --------------------------------- |
| 1               | Box-Cox transformation parameter  |
| {0,0}           | ARMA error                        |
| -               | Damping parameter                 |
| {\<51.18,14\>}  | Seasonal period, Fourier terms    |

<br>
 
The `gas` data contains Australian monthly gas production. A plot of the data shows the variance has changed a lot over time, so it needs a transformation. The seasonality has also changed shape over time, and there is a strong trend. This makes it an ideal series to test the `tbats()` function which is designed to handle these features.

`gas` is available to use in your workspace.

*** =instructions

- Plot `gas` using the standard plotting function.
- Fit a TBATS model using the newly introduced method to the gas data as `fit`.
- Forecast the series for the next 5 years as `fc`.
- Plot the forecasts of `fc`. Inspect the graph title by reviewing the table above.
- Save the Box-Cox parameter to 3 decimal places and order of Fourier terms to `lambda` and `K`, respectively.

*** =hint

- To fit a TBATS model in the second part of the exercise, use `tbats(gas)`. No pipe functions are needed in this exercise.
- The value of `h` in `forecast()` should be equivalent to the total number of months in 5 years, or 12 * 5.
- The forecasts plot title is `Forecasts from TBATS(0.082, {0,0}, 1, {<12,5>})`. Use the table to determine which values re`lambda` and `K`.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the gas data
___(___)

# Fit a TBATS model to the gas data
fit <- ___(___)

# Forecast the series for the next 5 years
fc <- ___(___)

# Plot the forecasts
___(___)

# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- ___
K <- ___
```

*** =solution
```{r}
# Plot the gas data
autoplot(gas)

# Fit a TBATS model to the gas data
fit <- tbats(gas)

# Forecast the series for the next 5 years
fc <- forecast(fit, h = 12 * 5)

# Plot the forecasts
autoplot(fc)

# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- 0.082
K <- 5
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` on `gas`?', append = FALSE)
    
    check_function(., "tbats") %>% check_arg("y") %>% check_equal(incorrect_msg = 'Did you call `tbats()` on `gas`?', append = FALSE)
    check_object(., "fit") %>% check_equal()
    
    check_function(., "forecast") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = "Are you forecasting the model `fit`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "Are you forecasting the next 5 years (in months) ahead?", append = FALSE)
    }
    check_object(., "fc")
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = 'Did you call `autoplot()` on `fc`?', append = FALSE, eval = FALSE)
    
    check_object(., "lambda") %>% check_equal(incorrect_msg = "Print `fit` to look at the output: `TBATS(Box-Cox parameter, {..., ...}, ..., {<..., ...>})`", append = FALSE)
    check_object(., "K") %>% check_equal(incorrect_msg = "Print `fit` to look at the output: `TBATS(..., {..., ...}, ..., {<..., Fourier terms>})`", append = FALSE)
}

success_msg("Amazing! Just remember that completely automated solutions don't work every time.")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:0653795481
## Your future in forecasting!
*** =video_hls 
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch5_4.master.m3u8

