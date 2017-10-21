---
title: Exploring and visualizing time series in R
description: >-
  The first thing to do in any data analysis task is to plot the data. Graphs
  enable many features of the data to be visualized, including patterns, unusual
  observations, and changes over time. The features that are seen in plots of
  the data must then be incorporated, as far as possible, into the forecasting
  methods to be used.
attachments : 
  slides_link : https://s3.amazonaws.com/assets.datacamp.com/production/course_3002/slides/ch1.pdf
free_preview: TRUE

--- type:VideoExercise lang:r xp:50 skills:1 key:d67a372b35
## Welcome to the course!

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch1_1.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:cb3a372cf0
## Creating time series objects in R

A **time series** can be thought of as a vector or matrix of numbers along with some information about what times those numbers were recorded. This information is stored in a `ts` object in R. In most exercises, you will use time series that are part of existing packages. However, if you want to work with your own data, you need to know how to create a `ts` object in R.

Let's look at an example `usnim_2002` below, containing net interest margins for US banks for the year 2002 (source: FFIEC).

```
> usnim_2002
               usnim
1   2002-01-01  4.08
2   2002-04-01  4.10
3   2002-07-01  4.06
4   2002-10-01  4.04

> # ts(data, start, frequency, ...)
> usnim_ts = ts(usnim_2002[, 2], start = c(2002, 1), frequency = 4)
```

The function `ts()` takes in three arguments:

- `data` is set to everything in `usnim_2002` except for the date column; it isn't needed since the `ts` object will store time information separately.
- `start` is set to the form `c(year, period)` to indicate the time of the first observation. Here, January corresponds with period 1; likewise, a start date in April would refer to 2, July to 3, and October to 4. Thus, *period* corresponds to the *quarter* of the year.
- `frequency` is set to 4 because the data are quarterly. 

In this exercise, you will read in some time series data from an xlsx file using `read_excel()`, a function from the `readxl` package, and store the data as a `ts` object. Both the xlsx file and  package have been loaded into your workspace.

*** =instructions

- Use the `read_excel()` function to read the data from `"exercise1.xlsx"` into `mydata`.
- Apply `head()` to `mydata` in the R console to inspect the first few lines of the data. Take a look at the dates - there are four observations in 1981, indicating quarterly data with a *frequency* of four rows per year. The first observation or *start* date is `Mar-81`, the first of four rows for *year* 1981, indicating that March corresponds with the first *period*. 
- Create a `ts` object called `myts` using `ts()`. Set `data`, `start` and `frequency` based on what you observed.

*** =hint

Check that you have correctly:

- Remove the date column in `mydata` by correctly subsetting all rows and all but the first column, then set this to the first argument in `ts()`.
- Set the year as 1981 and period as 1 (since *March* belongs to the first quarter of the year) for the start date in form `c(year, period)`.
- Set the `frequency` value to 4 because the contents of `mydata` are quarterly.

*** =pre_exercise_code
```{r}
download.file("http://s3.amazonaws.com/assets.datacamp.com/production/course_3002/datasets/exercise1.xlsx", 
  destfile = "exercise1.xlsx")
library("readxl")
```

*** =sample_code
```{r}
# Read the data from Excel into R
___ <- ___("exercise1.xlsx")

# Look at the first few lines of mydata
___

# Create a ts object called myts
myts <- ts(___[___], start = c(___, ___), frequency = ___)
```

*** =solution
```{r}
# Read the data from Excel into R
mydata <- read_excel("exercise1.xlsx")

# Look at the first few lines of mydata
head(mydata)

# Create a ts object called myts
myts <- ts(mydata[, 2:4], start = c(1981, 1), frequency = 4)
```

*** =sct
```{r}
ex() %>% {
    check_error(.)
    check_function(., "read_excel") %>% check_arg("path") %>% check_equal(incorrect_msg = 'Have you read the data from `"exercise1.xlsx"`?', append = FALSE)
    check_object(., "mydata") %>% check_equal()
    check_function(., "head") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you look at the `head()` of `mydata`?", append = FALSE)
    check_function(., "ts") %>% {
        check_arg(., "data") %>% check_equal(incorrect_msg = "Did you include columns 2 through 4 of `mydata` as the first argument to `ts`?", append = FALSE)
        check_arg(., "start") %>% check_equal(incorrect_msg = "Based on the first row of `mydata`, you should set `start` to `c(year, quarter)`.", append = FALSE)
        check_arg(., "frequency") %>% check_equal(incorrect_msg = "Based on the number of entries in `mydata` that correspond to one year, did you choose the correct frequency?", append = FALSE)
    }
}

success_msg("Nice work. You have now created a time series object from external data.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:1f329c6eb9
## Time series plots

The first step in any data analysis task is to plot the data. Graphs enable you to visualize many features of the data, including patterns, unusual observations, changes over time, and relationships between variables. Just as the type of data determines which **forecasting** method to use, it also determines which graphs are appropriate.

You can use the `autoplot()` function to produce a **time plot** of the data with or without facets, or panels that display different subsets of data:

```
> autoplot(usnim_2002, facets = FALSE)
```

The above method is one of the many taught in this course that accepts boolean arguments. Both `T` and `TRUE` mean "true", and `F` and `FALSE` mean "false", however, `T` and `F` can be overwritten in your code. Therefore, you should *only* rely on `TRUE` and `FALSE` to set your indicators for the remainder of the course. 

You will use two more functions in this exercise, `which.max()` and `frequency()`.  
`which.max()` can be used to identify the smallest index of the maximum value

```
> x <- c(4, 5, 5)
> which.max(x)
[1] 2
```
To find the number of observations per unit time, use `frequency()`. Recall the `usnim_2002` data from the previous exercise:

```
> frequency(usnim_2002)
[1] 4
```

Because this course involves the use of the `forecast` and `ggplot2` packages, they have been loaded into your workspace for you, as well as `myts` from the previous exercise and the following three series (available in the package `forecast`):

- `gold` containing gold prices in US dollars
- `woolyrnq` containing information on the production of woollen yarn in Australia
- `gas` containing Australian gas production

*** =instructions

- Plot the data you stored as `myts` using `autoplot()` with facetting.
- Plot the same data without facetting by setting the appropriate argument to `FALSE`. What happens?
- Plot the `gold`, `woolyrnq`, and `gas` time series in separate plots.
- Use `which.max()` to spot the outlier in the `gold` series. Which observation was it?
- Apply the `frequency()` function to each commodity to get the number of observations per unit time. This would return 52 for weekly data, for example.

*** =hint

Do not forget to set `facets = TRUE` first and then `= FALSE`.

*** =pre_exercise_code
```{r}
download.file("http://s3.amazonaws.com/assets.datacamp.com/production/course_3002/datasets/exercise1.xlsx", 
  destfile = "exercise1.xlsx")
myts <- ts(readxl::read_excel("exercise1.xlsx")[,2:4], start = 1981, frequency = 4)
library(forecast)
library(ggplot2)
```

*** =sample_code
```{r}
# Plot the data with facetting
autoplot(___, facets = ___)

# Plot the data without facetting
___

# Plot the three series
autoplot(___)
___
___

# Find the outlier in the gold series
goldoutlier <- ___(___)

# Look at the seasonal frequencies of the three series
frequency(___)
___
___
```

*** =solution
```{r}
# Plot the data with facetting
autoplot(myts, facets = TRUE)

# Plot the data without facetting
autoplot(myts, facets = FALSE)

# Plot the three series
autoplot(gold)
autoplot(woolyrnq)
autoplot(gas)

# Find the outlier in the gold series
goldoutlier <- which.max(gold)

# Look at the seasonal frequencies of the three series
frequency(gold)
frequency(woolyrnq)
frequency(gas)
```

*** =sct
```{r}
msg1 <- "In your %s call to `autoplot()`, did you set the first argument to `myts`?"
msg2 <- "In your %s call to `autoplot()`, did you set the `facets` argument to `%s`?"
msg3 <- "Did you call `autoplot()` on `%s` with no additional arguments?"
msg4 <- "Did you call `frequency()` on `%s` with no additional arguments?"

ex() %>% {
    check_error(.)
    check_function(., "autoplot") %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg1, "first"), append = FALSE)
        check_arg(., "facets") %>% check_equal(incorrect_msg = sprintf(msg2, "first", "TRUE"), append = FALSE)
    }
    check_function(., "autoplot", index = 2) %>% {
        check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg1, "second"), append = FALSE)
        check_arg(., "facets") %>% check_equal(incorrect_msg = sprintf(msg2, "second", "FALSE"), append = FALSE)
    }
    
    check_function(., "autoplot", index = 3) %>% check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg3, "gold"), append = FALSE)
    check_function(., "autoplot", index = 4) %>% check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg3, "woolyrnq"), append = FALSE)
    check_function(., "autoplot", index = 5) %>% check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg3, "gas"), append = FALSE)
    
    check_function(., "which.max") %>% check_arg("x") %>% check_equal(incorrect_msg = "Did you call `which.max()` on `gold` to spot the outlier?", append = FALSE)
    check_object(., "goldoutlier") %>% check_equal(incorrect_msg = "Something is wrong with `goldoutlier`. It should contain the index to the outlier in the `gold` series.", append = FALSE)
    
    check_function(., "frequency") %>% check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg4, "gold"), append = FALSE)
    check_function(., "frequency", index = 2) %>% check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg4, "woolyrnq"), append = FALSE)
    check_function(., "frequency", index = 3) %>% check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg4, "gas"), append = FALSE)
}

success_msg("Excellent. You can now produce time series plots as well as identify seasonal frequencies.")
```

--- type:NormalExercise lang:r xp:100 skills:1 key:8d039a95d5
## Seasonal plots

Along with time plots, there are other useful ways of plotting data to emphasize seasonal patterns and show changes in these patterns over time.

- A **seasonal plot** is similar to a time plot except that the data are plotted against the individual “seasons” in which the data were observed. You can create one using the `ggseasonplot()` function the same way you do with `autoplot()`.
- An interesting variant of a season plot uses polar coordinates, where the time axis is circular rather than horizontal; to make one, simply add a `polar` argument and set it to `TRUE`.
- A **subseries plot** comprises mini time plots for each season. Here, the mean for each season is shown as a blue horizontal line.

One way of splitting a time series is by using the `window()` function, which extracts a subset from the object `x` observed between the times `start` and `end`.

```
> window(x, start = NULL, end = NULL)
```

In this exercise, you will load the `fpp2` package and use two of its datasets:

- `a10` contains monthly sales volumes for anti-diabetic drugs in Australia. In the plots, can you see which month has the highest sales volume each year? What is unusual about the results in March and April 2008?
- `ausbeer` which contains quarterly beer production for Australia. What is happening to the beer production in Quarter 4?

These examples will help you to visualize these plots and understand how they can be useful.


*** =instructions

- Use `library()` to load the `fpp2` package.
- Use `autoplot()` and `ggseasonplot()` to produce plots of the `a10` data.
- Use the `ggseasonplot()` function and its `polar` argument to produce a polar coordinate plot for the `a10` data.
- Use the `window()` function to consider only the `ausbeer` data *starting* from 1992.
- Finally, use `autoplot()` and `ggsubseriesplot()` to produce plots of the `beer` series.

*** =hint

For the third and fourth instructions, use the designated plotting function with the first argument set to the variable holding the data you want to plot, and the second argument set to the form `keyword = value`. In these cases, the keyword `polar` will hold a boolean and the keyword `start` will hold an integer (`YYYY`).

*** =pre_exercise_code
```{r}
library(forecast)
library(ggplot2)
```

*** =sample_code
```{r}
# Load the fpp2 package
___

# Create plots of the a10 data
___
___

# Produce a polar coordinate season plot for the a10 data
ggseasonplot(___, polar = ___)

# Restrict the ausbeer data to start in 1992
beer <- ___(___, ___)

# Make plots of the beer data
___
___
```

*** =solution
```{r}
# Load the fpp2 package
library(fpp2)

# Create plots of the a10 data
autoplot(a10)
ggseasonplot(a10)

# Produce a polar coordinate season plot for the a10 data
ggseasonplot(a10, polar = TRUE)

# Restrict the ausbeer data to start in 1992
beer <- window(ausbeer, start = 1992)

# Make plots of the beer data
autoplot(beer)
ggsubseriesplot(beer)
```

*** =sct
```{r}
# Check fpp2 is loaded
test_library_function("fpp2", not_called_msg = "Make sure you load the `fpp2` package.")

msg1 <- "Did you call `%s()` on `%s` with no additional arguments?"
msg2 <- "In your call to `%s()`, did you set the %s argument to `%s`?"

ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "a10"), append = FALSE)
    check_function(., "ggseasonplot") %>% check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg1, "ggseasonplot", "a10"), append = FALSE)
    
    check_function(., "ggseasonplot", index = 2) %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg2, "ggseasonplot", "first", "a10"), append = FALSE)
        check_arg(., "polar") %>% check_equal(incorrect_msg = sprintf(msg2, "ggseasonplot", "`polar`", "TRUE"), append = FALSE)
    }
    
    check_function(., "window") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg2, "window", "first", "ausbeer"), append = FALSE)
        check_arg(., "start")
    }
}

check_or(
    ex() %>% check_code(., "start = 1992", fixed = TRUE, append = FALSE, missing_msg = sprintf(msg2, "window", "`start`", "1992")), 
    ex() %>% check_code(., "start = c(1992, 1)", fixed = TRUE, append = FALSE, missing_msg = sprintf(msg2, "window", "`start`", "1992"))
)

ex() %>% {
    check_object(., "beer")
    
    check_function(., "autoplot", index = 2) %>% check_arg(., "object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "beer"), append = FALSE)
    check_function(., "ggsubseriesplot") %>% check_arg(., "x") %>% check_equal(incorrect_msg = sprintf(msg1, "ggsubseriesplot", "beer"), append = FALSE)
}

success_msg("Excellent! You can now produce three different types of plots for studying seasonality.")
```

--- type:VideoExercise lang:r xp:50 skills:1 key:ac51deabfc
## Trends, seasonality and cyclicity

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch1_2.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:48d34d60b8
## Autocorrelation of non-seasonal time series

Another way to look at time series data is to plot each observation against another observation that occurred some time previously by using `gglagplot()`. For example, you could plot $y\_t$ against $y\_{t-1}$. This is called a lag plot because you are plotting the time series against lags of itself.

The correlations associated with the lag plots form what is called the **autocorrelation function (ACF)**. The `ggAcf()` function produces ACF plots.

In this exercise, you will work with the pre-loaded `oil` data (available in the package `fpp2`), which contains the annual oil production in Saudi Arabia from 1965-2013 (measured in millions of tons).

*** =instructions

- Use the `autoplot()` function to plot the `oil` data.
- For the `oil` data, plot the relationship between $y\_t$ and $y\_{t-k}$, $k=1,\dots,9$ using one of the two functions introduced above. Look at how the relationships change as the lag increases.
- Likewise, plot the correlations associated with each of the lag plots using the other appropriate new function.

*** =hint

- The trend in the data causes the autocorrelations for the first few lags to be positive.
- The dashed blue lines are critical values. Any correlations within these lines is not significantly different from zero.
- In this instance, no additional keywords are needed for these plotting functions.

*** =pre_exercise_code
```{r}
# Load fpp2 package
library(fpp2)
```

*** =sample_code
```{r}
# Create an autoplot of the oil data
___

# Create a lag plot of the oil data
___

# Create an ACF plot of the oil data
___
```

*** =solution
```{r}
# Create an autoplot of the oil data
autoplot(oil)

# Create a lag plot of the oil data
gglagplot(oil)

# Create an ACF plot of the oil data
ggAcf(oil)
```

*** =sct
```{r}
test_error()

test_function("autoplot", args = "object", incorrect_msg = "Did you use the `autoplot()` function to plot the `oil` time series?")

test_function("gglagplot", args = "x", incorrect_msg =  "Did you use the `gglagplot()` function to plot the `oil` time series?")

test_function("ggAcf", args = "x", incorrect_msg =  "Did you use the `ggAcf()` function to plot the 'oil' time series?")

success_msg("Great! You can now produce plots for lags and autocorrelations.")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:249ec07c07
## Autocorrelation of seasonal and cyclic time series

When data are either seasonal or cyclic, the ACF will peak around the seasonal lags or at the average cycle length.

You will investigate this phenomenon by plotting the annual sunspot series (which follows the solar cycle of approximately 10-11 years) in `sunspot.year` and the daily traffic to the Hyndsight blog (which follows a 7-day weekly pattern) in `hyndsight`. Both objects have been loaded into your workspace.


*** =instructions

- Produce a time plot and ACF plot of `sunspot.year`.
- By observing the ACF plot, at which lag value (x) can you find the maximum autocorrelation (y)? Set this equal to `maxlag_sunspot`.
- Produce a time plot and ACF plot of `hyndsight`.
- By observing the ACF plot, at which lag value (x) can you find the maximum autocorrelation (y)? Set this equal to `maxlag_hyndsight`.

*** =hint

Look at the ACF plot for `sunspot.year` and find the maximum ACF (y), or the tallest bar on the grpah. Its corresponding lag (x) is `1`, so, set it equal to `maxlag_sunspot`. Use this logic to find `maxlag_hyndsight` and then ensure that your observations agree with the following points:

- The sunspot data are annual, so they cannot be seasonal. The cycles are aperiodic of variable length.
- The ACF plots show peaks at seasonal lags and at the average cycle length.
- The ACF plots show positive and decreasing spikes when the series is trended.

*** =pre_exercise_code
```{r}
# Load fpp2 package
library(fpp2)
```

*** =sample_code
```{r}
# Plot the annual sunspot numbers
autoplot(___)
ggAcf(___)

# Save the lag corresponding to maximum autocorrelation
maxlag_sunspot <- ___

# Plot the traffic on the Hyndsight blog
___
___

# Save the lag corresponding to maximum autocorrelation
maxlag_hyndsight <- ___
```

*** =solution
```{r}
# Plots of annual sunspot numbers
autoplot(sunspot.year)
ggAcf(sunspot.year)

# Save the lag corresponding to maximum autocorrelation
maxlag_sunspot <- 1

# Plot the traffic on the Hyndsight blog
autoplot(hyndsight)
ggAcf(hyndsight)

# Save the lag corresponding to maximum autocorrelation
maxlag_hyndsight <- 7
```

*** =sct
```{r}

msg <- "Did you call `%s()` on `%s`?"

ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "sunspot.year"), append = FALSE)
    check_function(., "ggAcf") %>% check_arg("x") %>% check_equal(incorrect_msg = sprintf(msg, "ggAcf", "sunspot.year"), append = FALSE)
    
    check_object(., "maxlag_sunspot") %>% check_equal(incorrect_msg = "Look back at `ggAcf(sunspot.year)` to visually determine the lag (x) that corresponds with the maximum value for ACF (y).", append = FALSE)
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg, "autoplot", "hyndsight"), append = FALSE)
    check_function(., "ggAcf", index = 2) %>% check_arg("x") %>% check_equal(incorrect_msg = sprintf(msg, "ggAcf", "hyndsight"), append = FALSE)
    
    check_object(., "maxlag_hyndsight") %>% check_equal(incorrect_msg = "Look back at `ggAcf(hyndsight)` to visually determine the lag (x) that corresponds with the maximum value for ACF (y).", append = FALSE)
}

success_msg("Nice! You can now visualize seasonality in the ACF plots.")

```
--- type:MultipleChoiceExercise lang:r xp:50 skills:1 key:c8b3411c22
## Match the ACF to the time series

Now that you have seen ACF plots for various time series, you should be able to identify characteristics of the time series from the ACF plot alone.

Match the ACF plots shown (A-D) to their corresponding time plots (1-4).


*** =instructions

Select the correct pairs of plots:

- 1-B, 2-C, 3-D, 4-A
- 1-B, 2-A, 3-D, 4-C
- 1-C, 2-D, 3-B, 4-A
- 1-A, 2-C, 3-D, 4-B
- 1-C, 2-A, 3-D, 4-B


*** =hint

- Use the process of elimination - pair the easy ones first, then see what is left.
- Trends induce positive correlations in the early lags.
- Seasonality will induce peaks at the seasonal lags.
- Cyclicity induces peaks at the average cycle length.

*** =sct
```{r}
msg1 = "Try again."
msg2 = "Well done! Proceed to the next exercise."
msg3 = "Try again."
msg4 = "Try again."
msg5 = "Try again."
test_mc(correct = 2, feedback_msgs = c(msg1,msg2,msg3,msg4,msg5))
# General
test_error()
success_msg("Well spotted.")
```

*** =pre_exercise_code
```{r}
library(fpp2)
 tp1 <- autoplot(cowtemp) + xlab("") + ylab("chirps per minute") +
      ggtitle("1. Daily temperature of cow")
    tp2 <- autoplot(USAccDeaths/1e3) + xlab("") + ylab("thousands") +
      ggtitle("2. Monthly accidental deaths")
    tp3 <- autoplot(AirPassengers) + xlab("") + ylab("thousands") +
      ggtitle("3. Monthly air passengers")
    tp4 <- autoplot(mink/1e3) + xlab("") + ylab("thousands") +
      ggtitle("4. Annual mink trappings")
    acfb <- ggAcf(c(cowtemp), ci=0) + xlab("") + ggtitle("B") + ylim(-0.4,1)
    acfa <- ggAcf(c(USAccDeaths), ci=0) + xlab("") + ggtitle("A") + ylim(-0.4,1)
    acfd <- ggAcf(c(AirPassengers), ci=0) + xlab("") + ggtitle("D") + ylim(-0.4,1)
    acfc <- ggAcf(c(mink), ci=0) + xlab("") + ggtitle("C") + ylim(-0.4,1)
    gridExtra::grid.arrange(tp1,tp2,tp3,tp4,
                            acfa,acfb,acfc,acfd,nrow=2)
```


--- type:VideoExercise lang:r xp:50 skills:1 key:691b43d315
## White noise

*** =video_hls
//videos.datacamp.com/transcoded/3002_forecasting-using-r/v2/hls-ch1_3.master.m3u8

--- type:NormalExercise lang:r xp:100 skills:1 key:6344974bee
## Stock prices and white noise

As you learned in the video, **white noise** is a term that describes purely random data. You can conduct a Ljung-Box test using the function below to confirm the randomness of a series; a p-value greater than 0.05 suggests that the data are not significantly different from white noise.

```
> Box.test(pigs, lag = 24, fitdf = 0, type = "Ljung")
```

There is a well-known result in economics called the "Efficient Market Hypothesis" that states that asset prices reflect all available information. A consequence of this is that the daily changes in stock prices should behave like white noise (ignoring dividends, interest rates and transaction costs). The consequence for forecasters is that the best forecast of the future price is the current price.

You can test this hypothesis by looking at the `goog` series, which contains the closing stock price for Google over 1000 trading days ending on February 13, 2017. This data has been loaded into your workspace.


*** =instructions

- First plot the `goog` series using `autoplot()`.
- Using the `diff()` function with `autoplot()`, plot the daily changes in Google stock prices.
- Use the `ggAcf()` function to check if these daily changes look like white noise.
- Fill in the pre-written code to do a Ljung-Box test on the daily changes using 10 lags.

*** =hint

- To obtain a differenced series of the time series `x`, use `diff(x)`.
- To perform a Ljung-Box test using 10 lags, set the `lag` parameter to 10. 
- A small number of correlations outside the blue lines is expected. There are 29 spikes plotted here, and we would expect about 5% of them to be significant by chance. The Ljung-Box test indicates if the number and size of these is enough to think that the series is not white noise.


*** =pre_exercise_code
```{r}
library(fpp2)
```

*** =sample_code
```{r}
# Plot the original series
___

# Plot the differenced series
___

# ACF of the differenced series
___

# Ljung-Box test of the differenced series
___(___, lag = ___, type = "Ljung")
```

*** =solution
```{r}
# Plot the original series
autoplot(goog)

# Plot the differenced series
autoplot(diff(goog))

# ACF of the differenced series
ggAcf(diff(goog))

# Ljung-Box test of the differenced series
Box.test(diff(goog), lag = 10, type = "Ljung")
```

*** =sct
```{r}
msg1 <- "Did you call `%s()` on `%s`?"
msg2 <- 'Did you change the `type` argument of `Box.test()`? It should be set to either `"Ljung"` or `"Ljung-Box"`.'

ex() %>% {
    check_error(.)
    
    check_function(., "autoplot") %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "goog"), append = FALSE)
    
    check_function(., "autoplot", index = 2) %>% check_arg("object") %>% check_equal(incorrect_msg = sprintf(msg1, "autoplot", "diff(goog)"), append = FALSE)
    
    check_function(., "ggAcf") %>% check_arg("x") %>% check_equal(incorrect_msg = sprintf(msg1, "ggAcf", "diff(goog)"), append = FALSE)
    
    check_function(., "Box.test") %>% {
        check_arg(., "x") %>% check_equal(incorrect_msg = "Did you specify the first argument of `Box.test()` as the differenced series of `goog`?", append = FALSE)
        check_arg(., "lag") %>% check_equal()
        check_arg(., "type")
    }
}

check_or(
    ex() %>% check_code(., 'type = "Ljung"', fixed = TRUE, missing_msg = msg2, append = FALSE), 
    ex() %>% check_code(., 'type = "Ljung-Box"', fixed = TRUE, missing_msg = msg2, append = FALSE)
)

success_msg("Well done. You have seen that the Ljung-Box test was not significant, so daily changes in the Google stock price look like white noise.")
```