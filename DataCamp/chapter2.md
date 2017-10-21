---
title: Benchmark methods and forecast accuracy
description: >-
  In this chapter, you will learn general tools that are useful for many
  different forecasting situations. It will describe some methods for benchmark forecasting,
  methods for checking whether a forecasting method has adequately
  utilized the available information, and methods for measuring forecast accuracy. Each
  of the tools discussed in this chapter will be used repeatedly in subsequent
  chapters as you develop and explore a range of forecasting methods.
attachments : 
  slides_link : https://s3.amazonaws.com/assets.datacamp.com/production/course_3002/slides/ch2.pdf

--- type:VideoExercise lang:r xp:50 skills:1 key:dca5e0cc06
## Forecasts and potential futures

*** =video_hls
 //videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch2_1.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:703a2d07f0
## Naive forecasting methods

As you learned in the video, a **forecast** is the mean or median of simulated futures of a time series.

The very simplest forecasting method is to use the most recent observation; this is called a **naive** forecast and can be implemented in a namesake function. This is the best that can be done for many time series including most stock price data, and even if it is not a good forecasting method, it provides a useful benchmark for other forecasting methods.

For seasonal data, a related idea is to use the corresponding season from the last year of data. For example, if you want to forecast the sales volume for next March, you would use the sales volume from the previous March. This is implemented in the `snaive()` function, meaning, **seasonal naive**. 

For both forecasting methods, you can set the second argument `h`, which specifies the number of values you want to forecast; as shown in the code below, they have different default values. The resulting output is an object of class `forecast`. This is the core class of objects in the `forecast` package, and there are many functions for dealing with them including `summary()` and `autoplot()`.

```
naive(y, h = 10)
snaive(y, h = 2 * frequency(x))
```

You will try these two functions on the `goog` series and `ausbeer` series, respectively. These are available to use in your workspace.


*** =instructions

- Use `naive()` to forecast the next 20 values of the `goog` series, and save this to `fcgoog`.
- Plot and summarize the forecasts using `autoplot()` and `summary()`.
- Use `snaive()` to forecast the next 16 values of the `ausbeer` series, and save this to `fcbeer`.
- Plot and summarize the forecasts for `fcbeer` the same way you did for `fcgoog`.

*** =hint

- To forecast the next `y` values of `ex_series` using the imaginary method `forecast_func`, you would use `forecast_func(ex_series, h = y)`.
- `autoplot()` and `summary()` are "S3" methods. What they do depends on the class of the first argument passed to them. In this exercise, the `fcgoog` and `fcbeer` objects are of class `forecast`.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Use naive() to forecast the goog series
fcgoog <- naive(___, ___)

# Plot and summarize the forecasts
___(___)
___(___)

# Use snaive() to forecast the ausbeer series
fcbeer <- ___

# Plot and summarize the forecasts
___
___
```

*** =solution
```{r}
# Use naive() to forecast the goog series
fcgoog <- naive(goog, h = 20)

# Plot and summarize the forecasts
autoplot(fcgoog)
summary(fcgoog)

# Use snaive() to forecast the ausbeer series
fcbeer <- snaive(ausbeer, h = 16)

# Plot and summarize the forecasts
autoplot(fcbeer)
summary(fcbeer)
```

*** =sct
```{r}
msg1 <- "Did you call `%s()` on `%s`?"
msg2 <- "Check the first argument to `%s()`. Did you set it to `%s`?"

ex() %>% {
    check_error(.)
    
    check_function(., "naive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg2, "naive", "goog"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should be forecasting the next 20 values. Did you set `h` equal to 20?", append = FALSE)
    }
    check_expr(., "fcgoog$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of `naive()` to `fcgoog`?", append = FALSE)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "fcgoog"), append = FALSE, eval = FALSE)
    check_function(., "summary") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "summary", "fcgoog"), append = FALSE, eval = FALSE)
    
    check_function(., "snaive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg2, "snaive", "ausbeer"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = "You should be forecasting the next 16 values. Did you set `h` equal to 16?", append = FALSE)
    }
    check_expr(., "fcbeer$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of `snaive()` to `fcbeer`?", append = FALSE)
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "fcbeer"), append = FALSE, eval = FALSE)
    check_function(., "summary", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "summary", "fcbeer"), append = FALSE, eval = FALSE)
}

success_msg("Great job. You have naively forecasted non-seasonal and seasonal time series!")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:315cb3e722
## Fitted values and residuals

*** =video_hls
 //videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch2_2.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:93aab81cee
## Checking time series residuals

When applying a forecasting method, it is important to always check that the **residuals** are well-behaved (i.e., no outliers or patterns) and resemble white noise. The prediction intervals are computed assuming that the residuals are also normally distributed. You can use the `checkresiduals()` function to verify these characteristics; it will give the results of a Ljung-Box test.

You haven't used the pipe function (`%>%`) so far, but this is a good opportunity to introduce it. When there are many nested functions, pipe functions make the code much easier to read. To be consistent, always follow a function with parentheses to differentiate it from other objects, even if it has no arguments. An example is below:

```
> function(foo)       # These two
> foo %>% function()  # are the same!

> foo %>% function    # Inconsistent
```

In this exercise, you will test the above functions on the forecasts equivalent to what you produced in the previous exercise (`fcgoog` obtained after applying `naive()` to `goog`, and `fcbeer` obtained after applying `snaive()` to `ausbeer`).

*** =instructions

- Using the above pipe function, run `checkresiduals()` on a forecast equivalent to `fcgoog`.
- Based on this Ljung-Box test results, do the residuals resemble white noise? Assign `googwn` to either `TRUE` or `FALSE`.
- Using a similar pipe function, run `checkresiduals()` on a forecast equivalent to `fcbeer`.
- Based on this Ljung-Box test results, do the residuals resemble white noise? Assign `beerwn` to either `TRUE` or `FALSE`.

*** =hint

- One or two correlations just outside the critical values is ok. The probability of any single correlation being significant by chance is 5%. So with 30 correlations, we expect to see one or two significant spikes. The Ljung-Box test will tell you if the number and size of such spikes indicates a problem.
- The residuals for the `goog` series are clearly not normal. The "tails" of the distribution are too "heavy". This is typical of stock price data. It means that the prediction intervals (computed assuming normality) will have coverage a little larger than they should. For example, instead of covering 95% of actual values, they might cover 97% of actual values.
- Note that the residuals from the naive forecasts for `goog` are exactly the same as the daily changes in `goog` that we looked at in the last chapter.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Check the residuals from the naive forecasts applied to the goog series
goog %>% naive() %>% ___

# Do they look like white noise (TRUE or FALSE)
googwn <- ___

# Check the residuals from the seasonal naive forecasts applied to the ausbeer series
___

# Do they look like white noise (TRUE or FALSE)
beerwn <- ___
```

*** =solution
```{r}
# Check the residuals from the naive forecasts applied to the goog series
goog %>% naive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
googwn <- TRUE

# Check the residuals from the seasonal naive forecasts applied to the ausbeer series
ausbeer %>% snaive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
beerwn <- FALSE
```

*** =sct
```{r}
ex() %>% check_error()

check_correct({
    ex() %>% check_output_expr("goog %>% naive() %>% checkresiduals()")
}, {
    ex() %>% {
        check_function(., "naive") %>% check_arg("y") %>% check_equal(incorrect_msg = "Are you getting the `naive()` forecast for `goog`? Did you use the pipe function correctly?", append = FALSE)
        check_function(., "checkresiduals") %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the results of `naive()` into `checkresiduals()`?", append = FALSE)
    }
})

test_object("googwn", incorrect_msg = "You might want to look at the Ljung-Box test again. A p-value greater than 0.05 indicates data that resembles white noise.")

check_correct({
    ex() %>% check_output_expr("ausbeer %>% snaive() %>% checkresiduals()")
}, {
    ex() %>% {
        check_function(., "snaive") %>% check_arg("y") %>% check_equal(incorrect_msg = "Are you getting the `snaive()` forecast for `ausbeer`? Did you use the pipe function correctly?", append = FALSE)
        check_function(., "checkresiduals", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = "Did you pipe the results of `snaive()` into `checkresiduals()`?", append = FALSE)
    }
})

test_object("beerwn", incorrect_msg = "You might want to look at the Ljung-Box test again. A small p-value indicates that data does not resemble white noise.")

success_msg("Great job! You have naively forecasted non-seasonal and seasonal time series.")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:b8b33b33dc
## Training and test sets


*** =video_hls
 //videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch2_3.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:fcb0e90120
## Evaluating forecast accuracy of non-seasonal methods

In data science, a **training set** is a data set that is used to discover possible relationships. A **test set** is a data set that is used to verify the strength of these potential relationships. When you separate a data set into these parts, you generally allocate more of the data for training, and less for testing. 

One function that can be used to create training and test sets is `subset.ts()`, which returns a subset of a time series where the optional `start` and `end` arguments are specified using index values. 

```
> # x is a numerical vector or time series
> # To subset observations from 101 to 500
> train <- subset.ts(x, start = 101, end = 500, ...)

> # To subset the first 500 observations
> train <- subset.ts(x, end = 500, ...)
```

As you saw in the video, another function, `accuracy()`, computes various forecast accuracy statistics given the forecasts and the corresponding actual observations. It is smart enough to find the relevant observations if you give it more than the ones you are forecasting.

```
> # f is an object of class "forecast"
> # x is a numerical vector or time series
> accuracy(f, x, ...)
```

The accuracy measures provided include **root mean squared error (RMSE)** which is the square root of the mean squared error (MSE). Minimizing RMSE, which corresponds with increasing accuracy, is the same as minimizing MSE.

The pre-loaded time series `gold` comprises daily gold prices for 1108 days. Here, you'll use the first 1000 days as a training set, and compute forecasts for the remaining 108 days. These will be compared to the actual values for these days using the simple forcasting functions `naive()`, which you used earlier in this chapter, and `meanf()`, which gives forecasts equal to the mean of all observations. You'll have to specify the keyword `h` (which specifies the number of values you want to forecast) for both.

*** =instructions

- Use `subset.ts()` to create a training set for `gold` comprising the first 1000 observations. This will be called `train`.
- Compute forecasts of the test set, containing the remaining data, using `naive()` and assign this to `naive_fc`. Set `h` accordingly.
- Now, compute forecasts of the same test set using `meanf()` and assign this to `mean_fc`. Set `h` accordingly.
- Compare the forecast accuracy statistics of the two methods using the `accuracy()` function.
- Based on the above results, store the forecasts with the higher accuracy as `bestforecasts`.

*** =hint

- You will need to set the forecast horizon to be the same size as the test set, or, the number of observations *not included* in the training set. To find this value for `h`, take the difference of `length(gold)` and `length(train)`.
- A smaller error corresponds with higher accuracy. To find the better forecast, pick the one with the smaller RMSE after applying the `accuracy()` function.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Create the training data as train
train <- subset.ts(___, end = ___)

# Compute naive forecasts and save to naive_fc
naive_fc <- naive(___, h = ___)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(___, h = ___)

# Use accuracy() to compute RMSE statistics
accuracy(___, gold)
___(___, gold)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- ___
```

*** =solution
```{r}
# Create the training data as train
train <- subset.ts(gold, end = 1000)

# Compute naive forecasts and save to naive_fc
naive_fc <- naive(train, h = 108)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(train, h = 108)

# Use accuracy() to compute RMSE statistics
accuracy(naive_fc, gold)
accuracy(mean_fc, gold)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- naive_fc
```

*** =sct
```{r}
msg1 <- 'If you already accounted for 1000 observations in "gold", how many data points are left? Set this value to `h` in your call to `%s()`.'
msg2 <- "In your %s call to `accuracy()`, did you mention `%s` as the first argument?"
msg3 <- "Do not change the second argument to `accuracy()`."

ex() %>% {
    check_error(.)
    
    check_function(., "subset.ts") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Are you subsetting `gold`?", append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = "Is `end` specified as the first 1000 observations?", append = FALSE)
    }
    check_object(., "train") %>% check_equal(incorrect_msg = "Did you call `subset.ts()` on `gold` and assign the result to `train`?", append = FALSE)
    
    check_function(., "naive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Are you getting the `naive()` forecast for `train`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = sprintf(msg1, "naive"), append = FALSE)
    }
    check_expr(., "naive_fc$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of `naive()` to `naive_fc`?", append = FALSE)
    
    check_function(., "meanf") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = "Are you getting the `meanf()` forecast for `train`?", append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = sprintf(msg1, "meanf"), append = FALSE)
    }
    check_expr(., "mean_fc$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you assign the output of `meanf()` to `mean_fc`?", append = FALSE)
    
    check_function(., "accuracy") %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg2, "first", "naive_fc"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = msg3, append = FALSE)
    }
    
    check_function(., "accuracy", index = 2) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg2, "second", "mean_fc"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = msg3, append = FALSE)
    }
    
    check_expr(., "bestforecasts$mean") %>% check_result() %>% check_equal(incorrect_msg = "Did you store the forecasts with the higher accuracy as `bestforecasts`?", append = FALSE)
}

success_msg("Great job! You have compared two types of forecasts based on their RMSE.")

```

--- type:NormalExercise lang:r xp:100 skills:1 key:29fe1c93a3
## Evaluating forecast accuracy of seasonal methods

As you learned in the first chapter, the `window()` function specifies the `start` and `end` of a time series using the relevant times rather than the index values. Either of those two arguments can be formatted as a vector like `c(year, period)` which you have also previously used as an argument for `ts()`. *Again, __period__ refers to __quarter__ here.*

Here, you will use the Melbourne quarterly visitor numbers (`vn[, "Melbourne"]`) to create three different training sets, omitting the last 1, 2 and 3 years, respectively. Inspect the pre-loaded `vn` data in your console before beginning the exercise; this will help you determine the correct value to use for the keyword `h` (which specifies the number of values you want to forecast) in your forecasting methods.

Then for each training set, compute the next year of data, and finally compare the **mean absolute percentage error (MAPE)** of the forecasts using `accuracy()`. Why do you think that the MAPE vary so much?


*** =instructions

- Use `window()` to create three training sets from `vn[,"Melbourne"]`, omitting the last 1, 2 and 3 years; call these `train1`, `train2`, and `train3`, respectively. Set the `end` keyword accordingly.
- Compute one year of forecasts for each training set using the `snaive()` method. Call these `fc1`, `fc2`, and `fc3`, respectively.
- Following the structure of the sample code, compare the MAPE of the three sets of forecasts using the `accuracy()` function as your test set.

*** =hint

- The dates in the `vn` data set end in 2015 Q4. What does *quarterly* data tell you about the second value in the `end` vector in `window()` and the `h` value in `snaive()`? What does the year tell you about the first value in the `end` vector in `window()`?
- Once again, a smaller MAPE indicates a higher accuracy, so compare the outputs of the `accuracy()` function when applied to both forecasts.

*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Create three training series omitting the last 1, 2, and 3 years
train1 <- window(vn[, "Melbourne"], end = c(2014, 4))
train2 <- ___
train3 <- ___

# Produce forecasts using snaive()
fc1 <- snaive(___, h = ___)
fc2 <- ___
fc3 <- ___

# Use accuracy() to compare the MAPE of each series
accuracy(fc1, vn[, "Melbourne"])["Test set", "MAPE"]
___
___
```

*** =solution
```{r}
# Create three training series omitting the last 1, 2, and 3 years
train1 <- window(vn[, "Melbourne"], end = c(2014, 4))
train2 <- window(vn[, "Melbourne"], end = c(2013, 4))
train3 <- window(vn[, "Melbourne"], end = c(2012, 4))

# Produce forecasts using snaive()
fc1 <- snaive(train1, h = 4)
fc2 <- snaive(train2, h = 4)
fc3 <- snaive(train3, h = 4)

# Use accuracy() to compare the MAPE of each series
accuracy(fc1, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc2, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc3, vn[, "Melbourne"])["Test set", "MAPE"]
```

*** =sct
```{r}
msg1 <- 'In your %s call to `window()`, did you correctly subset the "Melbourne" column?'
msg2 <- 'In your %s call to `window()`, the parameter `end` should be of the form `c(year, quarter)`. You need to subtract %s from the last date in the "Melbourne" column to get the right _year_ and _quarter_.'
msg3 <- "Did you call `snaive()` on `%s`?"
msg4 <- "To compute one year of forecasts, you need to set `h` equal to the number of quarters in one year."
msg5 <- "In your %s call to `accuracy()`, did you set the first argument to `%s`?"
msg6 <- 'In your %s call to `accuracy()`, did you set the second argument to `vn[, "Melbourne"]`?'
msg7 <- 'After calculating the `accuracy()` of `%s`, did you correctly subset to print the MAPE for the test set?'
msg8 <- "Did you call `snaive()` on `%s` and assign the output to `%s`?"

ex() %>% {
    check_error(.)
    
    check_function(., "window") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg1, "first"), append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = sprintf(msg2, "first", "one year"), append = FALSE)
    }
    check_object(., "train1")
    
    check_function(., "window", index = 2) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg1, "second"), append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = sprintf(msg2, "second", "two years"), append = FALSE)
    }
    check_object(., "train2")
    
    check_function(., "window", index = 3) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg1, "third"), append = FALSE)
        check_arg(., "end") %>% check_equal(incorrect_msg = sprintf(msg2, "third", "three years"), append = FALSE)
    }
    check_object(., "train3")
    
    check_function(., "snaive") %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg3, "train1"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = msg4, append = FALSE)
    }
    check_expr(., "fc1$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg8, "train1", "fc1"), append = FALSE)
    
    check_function(., "snaive", index = 2) %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg3, "train2"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = msg4, append = FALSE)
    }
    check_expr(., "fc2$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg8, "train2", "fc2"), append = FALSE)
    
    check_function(., "snaive", index = 3) %>% {
        check_arg(., "y") %>% check_equal(incorrect_msg = sprintf(msg3, "train3"), append = FALSE)
        check_arg(., "h") %>% check_equal(incorrect_msg = msg4, append = FALSE)
    }
    check_expr(., "fc3$mean") %>% check_result() %>% check_equal(incorrect_msg = sprintf(msg8, "train3", "fc3"), append = FALSE)
    
    check_function(., "accuracy") %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg5, "first", "fc1"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg6, "first"), append = FALSE)
    }
    check_output_expr(., 'accuracy(fc1, vn[, "Melbourne"])["Test set", "MAPE"]', missing_msg = sprintf(msg7, "fc1"), append = FALSE)
    
    check_function(., "accuracy", index = 2) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg5, "second", "fc2"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg6, "second"), append = FALSE)
    }
    check_output_expr(., 'accuracy(fc2, vn[, "Melbourne"])["Test set", "MAPE"]', missing_msg = sprintf(msg7, "fc2"), append = FALSE)
    
    check_function(., "accuracy", index = 3) %>% {
        check_arg(., "f") %>% check_equal(incorrect_msg = sprintf(msg5, "third", "fc3"), append = FALSE, eval = FALSE)
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg6, "third"), append = FALSE)
    }
    check_output_expr(., 'accuracy(fc3, vn[, "Melbourne"])["Test set", "MAPE"]', missing_msg = sprintf(msg7, "fc3"), append = FALSE)
}

success_msg("Nice! Seasonal accuracy is just as easy to compare.")
```

--- type:PlainMultipleChoiceExercise lang:r xp:50 skills:1 key:156294f04c
## Do I have a good forecasting model?

*** =instructions

Which one of the following statements is true?

 - Good forecast methods should have normally distributed residuals.
 - A model with small residuals will give good forecasts.
 - If your model doesn’t forecast well, you should make it more complicated.
 - Where possible, try to find a model that has low RMSE on a test set and has white noise residuals.

*** =hint

- Normality of residuals makes calculation of prediction intervals easier, but it is not essential.
- Small residuals can be a sign that the training data has been over-fitted.
- Making a model more complicated can sometimes be helpful, but it might make the forecasts worse.

*** =sct
```{r}
msg1 = "No, normality of residuals makes life easier but is not essential."
msg2 = "No, small residuals only means that the model fits the training data well, not that it produces good forecasts."
msg3 = "No, making a model more complicated does not necessarily lead to better forecasts."
msg4 = ""
test_mc(correct = 4, feedback_msgs = c(msg1, msg2, msg3, msg4))
# General
test_error()
success_msg("Well done! A good model forecasts well (so has low RMSE on the test set) and uses all available information in the training data (so has white noise residuals).")

```

--- type:VideoExercise lang:r xp:50 skills:1 key:cad925720c
## Time series cross-validation

*** =video_hls
 //videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch2_4.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:b4bc54bf16
## Using tsCV() for time series cross-validation

The `tsCV()` function computes time series cross-validation errors. It requires you to specify the time series, the forecast method, and the forecast horizon. Here is the example used in the video:

```
> e = tsCV(oil, forecastfunction = naive, h = 1)
```

Here, you will use `tsCV()` to compute and plot the MSE values for up to 8 steps ahead, along with the `naive()` method applied to the `goog` data. The exercise uses `ggplot2` graphics which you may not be familiar with, but we have provided enough of the code so you can work out the rest.

Be sure to reference the slides on `tsCV()` in the lecture. The `goog` data has been loaded into your workspace.


*** =instructions

- Using the `goog` data and forecasting with the `naive()` function, compute the cross-validated errors for up to 8 steps ahead. Assign this to `e`.
- Compute the MSE values for each forecast horizon and remove missing values in `e` by specifying the second argument. The expression for calculating MSE has been provided.
- Plot the resulting MSE values (`y`) against the forecast horizon (`x`). Think through your knowledge of functions. If `MSE = mse` is provided in the list of function arguments, then `mse` should refer to an object that exists in your workspace *outside* the function, whereas `MSE` is the variable that you refers to this object *within* your function.

*** =hint

- To compute 10 steps ahead, you would use `for (h in 1:10) ...`. Apply this logic to compute 8 steps ahead.
- The `e` series will have missing values, so you will need to "turn on" the `na.rm` argument in `colMeans()` by setting it to `TRUE`.
- Remember to set `y = MSE` in `ggplot()`.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Compute cross-validated errors for up to 8 steps ahead
e <- matrix(NA_real_, nrow = 1000, ncol = 8)
for (h in ___:___)
  e[, h] <- tsCV(___, forecastfunction = ___, h = h)
  
# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = ___)

# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = ___)) + geom_point()
```

*** =solution
```{r}
# Compute cross-validated errors for up to 8 steps ahead
e <- matrix(NA_real_, nrow = 1000, ncol = 8)
for (h in 1:8)
  e[, h] <- tsCV(goog, forecastfunction = naive, h = h)
  
# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = TRUE)

# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()
```

*** =sct
```{r}

forloop <- ex() %>% check_for()
forloop %>% check_cond() %>% check_code("h in 1:8", missing_msg = "Did you define the for loop condition correctly? It should be `h in 1:8`.", fixed = TRUE, append = FALSE)
forloop %>% check_body() %>% check_function("tsCV") %>% {
  check_arg(., "y") %>% check_equal(incorrect_msg = "Did you call `tsCV()` on `goog`?", eval = FALSE)
  check_arg(., "forecastfunction") %>% check_equal(incorrect_msg = "Did you set the forecast function to `naive`?", eval = FALSE)
  check_arg(., "h") %>% check_equal(incorrect_msg = "Did you specify the argument `h` to be the same `h` that is the iterator of the for loop?", eval = FALSE)
}

msg <- "Do not change the code to create the matrix `e`."

ex() %>% {
    check_error(.)
    
    check_function(., "matrix") %>% {
        check_arg(., "data") %>% check_equal(incorrect_msg = msg, append = FALSE, eval = FALSE)
        check_arg(., "nrow") %>% check_equal(incorrect_msg = msg, append = FALSE)
        check_arg(., "ncol") %>% check_equal(incorrect_msg = msg, append = FALSE)
    }
    check_object(., "e") %>% check_equal(incorrect_msg = msg, append = FALSE)
    
    check_function(., "colMeans") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Do not update the first argument to `colMeans()`. It should be `e^2`.", append = FALSE, eval = FALSE)
        check_arg(., "na.rm") %>% check_equal(incorrect_msg = "Did you remove missing values by setting `na.rm = TRUE`?", append = FALSE)
    }
    
    check_function(., "ggplot") %>% check_arg(., "data") %>% check_equal(incorrect_msg = "Do not change the call to `data.frame()` that is piped into `ggplot()`.", append = FALSE)
    
    check_function(., "aes") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Do not update the `x` argument to `aes()`. It should be equal to `h`.", append = FALSE, eval = FALSE)
        check_arg(., "y") %>% check_equal(incorrect_msg = "Did you set `y` to `MSE` inside `aes()`?", append = FALSE, eval = FALSE)
    }
    
    check_function(., "geom_point")
    
}

success_msg("Great! Visualizations are a great way to get a deeper understanding of your model.")

```
