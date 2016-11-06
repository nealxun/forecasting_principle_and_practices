#Linear regression models {#ch4}

In this chapter we discuss linear regression models. The basic concept is that we forecast variable $y$ assuming it has a linear relationship with variable $x$. The model is called “simple” regression as we only allow one predictor variable $x$. In Chapter \@ref(ch5) we will discuss forecasting with several predictor variables.

The forecast variable $y$ is sometimes also called the regressand, dependent or
explained variable. The predictor variable $x$ is sometimes also called the
regressor, independent or explanatory variable. In this book we will always
refer to them as the “forecast variable” and “predictor variable”.

##The simple linear model {#sec-4-1-Intro}

In this chapter, the forecast and predictor variables are assumed to be related
by the simple linear model: $$y = \beta_0 + \beta_1 x + \varepsilon.$$ An
example of data from such a model is shown in Figure \@ref(fig-4-SLRpop1). The
parameters $\beta_0$ and $\beta_1$ determine the intercept and the slope of the
line respectively. The intercept $\beta_0$ represents the predicted value of
$y$ when $x=0$. The slope $\beta_1$ represents the predicted increase in $y$
resulting from a one unit increase in $x$.

![An example of data from a linear regression model.](Fig_CH4_SLRpop1)

\@ref(fig-4-SLRpop1)

Notice that the observations do not lie on the straight line but are scattered
around it. We can think of each observation $y_t$ consisting of the systematic
or explained part of the model, $\beta_0+\beta_1x_t$, and the random “error”,
$\varepsilon_t$. The “error” term does not imply a mistake, but a deviation
from the underlying straight line model. It captures anything that may affect
$y_t$ other than $x_t$.

We assume that these errors:

 - have mean zero; otherwise the forecasts will be systematically biased.
 - are not autocorrelated; otherwise the forecasts will be inefficient as there
   is more information to be exploited in the data.
 - are unrelated to the predictor variable; otherwise there would be more
   information that should be included in the systematic part of the model.

It is also useful to have the errors normally distributed with constant
variance in order to produce prediction intervals and to perform statistical
inference. While these additional conditions make the calculations simpler,
they are not necessary for forecasting.

Another important assumption in the simple linear model is that $x$ is not a
random variable. If we were performing a controlled experiment in a laboratory,
we could control the values of $x$ (so they would not be random) and observe
the resulting values of $y$. With observational data (including most data in
business and economics) it is not possible to control the value of $x$,
although they can still be non-random. For example, suppose we are studying the
effect of interest rates on inflation. Then $x$ is the interest rate and $y$ is
the rate of inflation. Interest rates are usually set by a committee and so
they are not random.

##Least squares estimation {#sec-4-2-LSprinciple}

In practice, of course, we have a collection of observations but we do not know
the values of $\beta_0$ and $\beta_1$. These need to be estimated from the
data. We call this “fitting a line through the data”.

There are many possible choices for $\beta_0$ and $\beta_1$, each choice giving
a different line. The least squares principle provides a way of choosing
$\beta_0$ and $\beta_1$ effectively by minimizing the sum of the squared
errors. That is, we choose the values of $\beta_0$ and $\beta_1$ that minimize
$$\sum_{t=1}^T \varepsilon_T^2 = \sum_{t=1}^T (y_t - \beta_0 - \beta_1x_t)^2.$$
Using mathematical calculus, it can be shown that the resulting **least squares
estimators** are $$\hat{\beta}_1=\frac{\displaystyle\sum_{t=1}^{T}(y_t-\bar{y})
(x_t-\bar{x})}{\displaystyle\sum_{t=1}^{T}(x_t-\bar{x})^2}$$ and
$$\hat{\beta}_0=\bar{y}-\hat{\beta}_1\bar{x},$$ where $\bar{x}$ is the average
of the $x$ observations and $\bar{y}$ is the average of the $y$ observations.

The *estimated* line is known as the “regression line” and is shown in Figure
[Fig~C~H4~S~LRpop2].

![Estimated regression line for a random sample of size $N$.](Fig_CH4_SLRpop2)

[Fig~C~H4~S~LRpop2]

We imagine that there is a “true” line denoted by $y=\beta_0+\beta_1x$ (shown
as the dashed green line in Figure [Fig~C~H4~S~LRpop2], but we do not know
$\beta_0$ and $\beta_1$ so we cannot use this line for forecasting. Therefore
we obtain estimates $\hat{\beta}_0$ and $\hat{\beta}_1$ from the observed data
to give the “regression line” (the solid purple line in Figure
[Fig~C~H4~S~LRpop2]).

The regression line is used for forecasting. For each value of $x$, we can
forecast a corresponding value of $y$ using
$\hat{y}=\hat{\beta}_0+\hat{\beta}_1x$.

### Fitted values and residuals {-}

The forecast values of $y$ obtained from the observed $x$ values are called
“fitted values”. We write these as $\hat{y}_t=\hat{\beta}_0+\hat{\beta}_1x_t$,
for $t=1,\dots,T$. Each $\hat{y}_t$ is the point on the regression line
corresponding to observation $x_t$.

The difference between the observed $y$ values and the corresponding fitted
$\hat{y}$ values are the “residuals”: $$e_t = y_t - \hat{y}_t = y_t
-\hat{\beta}_0-\hat{\beta}_1x_t.$$

The residuals have some useful properties including the following two:
$$\sum_{t=1}^{T}{e_t}=0 \quad\text{and}\quad \sum_{t=1}^{T}{x_te_t}=0.$$ As a
result of these properties, it is clear that the average of the residuals is
zero, and that the correlation between the residuals and the observations for
the predictor variable is also zero.

##Regression and correlation {#sec-4-RegrAndCorr}

The correlation coefficient $r$ was introduced in Section
\@ref(sec-2-2-NumSummaries). Recall that $r$ measures the strength and the direction
(positive or negative) of the linear relationship between the two variables.
The stronger the linear relationship, the closer the observed data points will
cluster around a straight line.

The slope coefficient $\hat{\beta}_1$ can also be expressed as
$$\hat{\beta}_1=r\frac{s_{y}}{s_x},$$ where $s_y$ is the standard deviation of
the $y$ observations and $s_x$ is the standard deviation of the $x$
observations.

So correlation and regression are strongly linked. The advantage of a
regression model over correlation is that it asserts a predictive relationship
between the two variables ($x$ predicts $y$) and quantifies this in a way that
is useful for forecasting.

[Car emissions]\@ref(ex-4-car)

![Fitted regression line from regressing the carbon footprint of cars versus
their fuel economy in city driving conditions.](fig_4_car)

\@ref(fig-4-car)

plot(jitter(Carbon)   jitter(City), xlab=“City (mpg)”, ylab=“Carbon footprint
(tons per year)”,data=fuel) fit \<- lm(Carbon   City, data=fuel) abline(fit)

\> summary(fit) Coefficients: Estimate Std. Error t value Pr(\>|t|)
(Intercept) 12.525647 0.199232 62.87 \<2e-16 \*\*\* City -0.220970 0.008878
-24.89 \<2e-16 \*\*\* --- Signif. codes: 0 \*\*\* 0.001 \*\* 0.01
\* 0.05 . 0.1 1

Residual standard error: 0.4703 on 132 degrees of freedom Multiple R-squared:
0.8244, Adjusted R-squared: 0.823 F-statistic: 619.5 on 1 and 132 DF, p-value:
\< 2.2e-16

Data on the carbon footprint and fuel economy for 2009 model cars were first
introduced in Chapter \@ref(ch1). A scatter plot of Carbon (carbon footprint in
tonnes per year) versus City (fuel economy in city driving conditions in miles
per gallon) for all 134 cars is presented in Figure \@ref(fig-4-car). Also plotted
is the estimated regression line $$\hat{y}=12.53-0.22x.$$ The regression
estimation output from R is also shown. Notice the coefficient estimates in the
column labelled “Estimate”. The other features of the output will be explained
later in this chapter.

**Interpreting the intercept**, $\hat{\beta}_0=12.53$. A car that has fuel
economy of $0$ mpg in city driving conditions can expect an average carbon
footprint of $12.53$ tonnes per year. As often happens with the intercept, this
is a case where the interpretation is nonsense as it is impossible for a car to
have fuel economy of $0$ mpg.

The interpretation of the intercept requires that a value of $x=0$ makes sense.
When $x=0$ makes sense, the intercept $\hat{\beta}_0$ is the predicted value of
$y$ corresponding to $x=0$. Even when $x=0$ does not make sense, the intercept
is an important part of the model. Without it, the slope coefficient can be
distorted unnecessarily.

**Interpreting the slope**, $\hat{\beta}_1=-0.22$. For every extra mile per
gallon, a car’s carbon footprint will decrease on average by 0.22 tonnes per
year. Alternatively, if we consider two cars whose fuel economies differ by 1
mpg in city driving conditions, their carbon footprints will differ, on
average, by 0.22 tonnes per year (with the car travelling further per gallon of
fuel having the smaller carbon footprint).

##Evaluating the regression model {#sec-4-4-EvaluatingSLR}

### Residual plots {-}

Recall that each residual is the unpredictable random component of each
observation and is defined as $$e_t=y_t-\hat{y}_t,$$ for $i=1,\dots,T$. We
would expect the residuals to be randomly scattered without showing any
systematic patterns. A simple and quick way for a first check is to examine a
scatterplot of the residuals against the predictor variable.

![Residual plot from regressing carbon footprint versus fuel economy in city
driving conditions.](fig_4_car_Res)

\@ref(fig-4-car-Res)

res \<- residuals(fit) plot(jitter(res)   jitter(City), ylab=“Residuals”,
xlab=“City”, data=fuel) abline(0,0)

A non-random pattern may indicate that a non-linear relationship may be
required, or some heteroscedasticity is present (i.e., the residuals show non-
constant variance), or there is some left over serial correlation (only when
the data are time series).

Figure \@ref(fig-4-car-Res) shows that the residuals from the Car data example
display a pattern rather than being randomly scattered. Residuals corresponding
to the lowest of the City values are mainly positive, for City values between
20 and 30 the residuals are mainly negative, and for larger City values (above
30 mpg) the residuals are positive again.

This suggests the simple linear model is not appropriate for these data.
Instead, a non-linear model will be required.

### Outliers and influential observations {-}

Observations that take on extreme values compared to the majority of the data
are called “outliers”. Observations that have a large influence on the
estimation results of a regression model are called “influential observations”.
Usually, influential observations are also outliers that are extreme in the $x$
direction.

[Predicting weight from height]

![The effect of outliers and influential observations on
regression.](fig_4_outliers)

\@ref(fig-4-outliers)

In Figure \@ref(fig-4-outliers) we consider simple linear models for predicting the
weight of 7 year old children by regressing weight against height. The two
samples considered are identical except for the one observation that is an
outlier. In the first row of plots the outlier is a child who weighs 35kg and
is 120cm tall. In the second row of plots the outlier is a child who also
weighs 35kg but is much taller at 150cm (so more extreme in the $x$ direction).
The black lines are the estimated regression lines when the outlier in each
case is not included in the sample. The red lines are the estimated regression
lines when including the outliers. Both outliers have an effect on the
regression line, but the second has a much bigger effect --- so we call it an
influential observation. The residual plots show that an influential
observation does not always lead to a large residual.

There are formal methods for detecting outliers and influential observations
that are beyond the scope of this textbook. As we suggested at the beginning of
Chapter \@ref(ch2), getting familiar with your data prior to performing any
analysis is of vital importance. A scatter plot of $y$ against $x$ is always a
useful starting point in regression analysis and often helps to identify
unusual observations.

One source for an outlier occurring is an incorrect data entry. Simple
descriptive statistics of your data can identify minima and maxima that are not
sensible. If such an observation is identified, and it has been incorrectly
recorded, it should be immediately removed from the sample.

Outliers also occur when some observations are simply different. In this case
it may not be wise for these observations to be removed. If an observation has
been identified as a likely outlier it is important to study it and analyze the
possible reasons behind it. The decision of removing or retaining such an
observation can be a challenging one (especially when outliers are influential
observations). It is wise to report results both with and without the removal
of such observations.

### Goodness {-}-of-fit

A common way to summarize how well a linear regression model fits the data is
via the coefficient of determination or $R^2$. This can be calculated as **the
square of the correlation between the observed $y$ values and the predicted
$\hat{y}$ values**. Alternatively, it can also be calculated as: $$R^2 =
\frac{\sum(\hat{y}_{t} - \bar{y})^2}{\sum(y_{t}-\bar{y})^2},$$ where the
summations are over all observations. Thus, it is also **the proportion of
variation in the forecast variable that is accounted for (or explained) by the
regression model**.

If the predictions are close to the actual values, we would expect $R^2$ to be
close to 1. On the other hand, if the predictions are unrelated to the actual
values, then $R^2=0$. In all cases, $R^2$ lies between 0 and 1.

In simple linear regression, the value of $R^2$ is also equal to the square of
the correlation between $y$ and $x$. In the car data example $r=-0.91$, hence
$R^2=0.82$. The coefficient of determination is presented as part of the R
output obtained when estimation a linear regression and is labelled “`Multiple
R-squared: 0.8244`” in Figure \@ref(fig-4-car). Thus, 82% of the variation in the
carbon footprint of cars is captured by the model. However, a “high” $R^2$ does
not always indicate a good model for forecasting. Figure \@ref(fig-4-car-Res) shows
that there are specific ranges of values of $y$ for which the fitted $y$ values
are systematically under- or over-estimated.

The $R^2$ value is commonly used, often incorrectly, in forecasting. There are
no set rules of what a good $R^2$ value is and typical values of $R^2$ depend
on the type of data used. Validating a model’s forecasting performance on the
test data is much better than measuring the $R^2$ value on the training data

### Standard error of the regression {-}

Another measure of how well the model has fitted the data is the standard
deviation of the residuals, which is often known as the “standard error of the
regression” and is calculated by

$$\label{eq-4-se} s_e=\sqrt{\frac{1}{T-2}\sum_{t=1}^{T}{e_t^2}}.$$

Notice that this calculation is slightly different from the usual standard
deviation where we divide by $T-1$ (see p.). Here, we divide by $T-2$ because
we have estimated two parameters (the intercept and slope) in computing the
residuals. Normally, we only need to estimate the mean (i.e., one parameter)
when computing a standard deviation. The divisor is always $T$ minus the number
of parameters estimated in the calculation.

The standard error is related to the size of the average error that the model
produces. We can compare this error to the sample mean of $y$ or with the
standard deviation of $y$ to gain some perspective on the accuracy of the
model. In Figure \@ref(fig-4-car), $s_e$ is part of the R output labeled “`Residual
standard error`” and takes the value 0.4703 tonnes per year.

We should warn here that the evaluation of the standard error can be highly
subjective as it is scale dependent. The main reason we introduce it here is
that it is required when generating forecast intervals, discussed in Section
\@ref(sec-4-5-ForeWithRegr).

##Forecasting with regression {#sec-4-5-ForeWithRegr}

Forecasts from a simple linear model are easily obtained using the equation
$$\hat{y}=\hat{\beta}_0+\hat{\beta}_1 x$$ where $x$ is the value of the
predictor for which we require a forecast. That is, if we input a value of $x$
in the equation we obtain a corresponding forecast $\hat{y}$.

When this calculation is done using an observed value of $x$ from the data, we
call the resulting value of $\hat{y}$ a “fitted value”. This is not a genuine
forecast as the actual value of $y$ for that predictor value was used in
estimating the model, and so the value of $\hat{y}$ is affected by the true
value of $y$. When the values of $x$ is a new value (i.e., not part of the data
that were used to estimate the model), the resulting value of $\hat{y}$ is a
genuine forecast.

Assuming that the regression errors are normally distributed, an approximate
95% **forecast interval** (also called a prediction interval) associated with
this forecast is given by

$$\label{eq-4-pi}
\hat{y} \pm 1.96 s_e\sqrt{1+\frac{1}{T}+\frac{(x-\bar{x})^2}{(T-1)s_x^2}},$$

where $N$ is the total number of observations, $\bar{x}$ is the mean of the
observed $x$ values, $s_x$ is the standard deviation of the observed $x$ values
and $s_e$ is given by equation . Similarly, an 80% forecast interval can be
obtained by replacing 1.96 by 1.28 in equation . Other appropriate forecasting
intervals can be obtained by replacing the 1.96 with the appropriate value
given in Table \@ref(tab-2-pcmultipiers). If R is used to obtain forecast intervals,
more exact calculations are obtained (especially for small values of $T$) than
what is given by equation .

Equation  shows that the forecast interval is wider when $x$ is far from
$\bar{x}$. That is, we are more certain about our forecasts when considering
values of the predictor variable close to its sample mean.

The estimated regression line in the Car data example is
$$\hat{y}=12.53-0.22x.$$ For the Chevrolet Aveo (the first car in the list)
$x_1$=25 mpg and $y_1=6.6$ tons of CO$_2$ per year. The model returns a fitted
value of $\hat{y}_1$=7.00, i.e., $e_1=-0.4$. For a car with City driving fuel
economy $x=30$ mpg, the average footprint forecasted is $\hat{y}=5.90$ tons of
CO$_2$ per year. The corresponding 95% and 80% forecast intervals are [4.95,
6.84] and [5.28, 6.51] respectively (calculated using R).

![Forecast with 80% and 95% forecast intervals for a car with $x=30$ mpg in
city driving.](fig_4_car2)

fitted(fit)\@ref(1) fcast \<- forecast(fit, newdata=30) plot(fcast, xlab=“City
(mpg)”, ylab=“Carbon footprint (tons per year)”) \# The displayed graph uses
jittering, while the code above does not.

##Statistical inference {#sec-4-6-Inference}

***(This section is an optional digression.)***

As well as being used for forecasting, simple linear regression models are also
valuable in studying the historical effects of predictors. The analysis of the
historical effect of a predictor uses statistical inference methods.

### Hypothesis testing {-}

If you are an analyst then you may also be interested in testing whether the
predictor variable $x$ has had an identifiable effect on $y$. That is, you may
wish to explore whether there is enough evidence to show that $x$ and $y$ are
related.

We use statistical hypothesis testing to formally examine this issue. If $x$
and $y$ are unrelated, then the slope parameter $\beta_1=0$. So we can
construct a test to see if it is plausible that $\beta_1=0$ given the observed
data.

The logic of hypothesis tests is to assume that the hypothesis you want to
*disprove* is true, and then to look for evidence that the assumption is wrong.
In this case, we assume that there is no relationship between $x$ and $y$. This
is called the “null hypothesis” and is stated as $$H_0:\beta_1=0.$$ Evidence
against this hypothesis is provided by the value of $\hat{\beta}_1$, the slope
estimated from the data. If $\hat{\beta}_1$ is very different from zero, we
conclude that the null hypothesis is incorrect and that the evidence suggests
there really is a relationship between $x$ and $y$.

To determine how big the difference between $\hat{\beta}_1$ and $\beta_1$ must
be before we would reject the null hypothesis, we calculate the probability of
obtaining a value of $\hat{\beta}_1$ as large as we have calculated if the null
hypothesis were true. This probability is known as the “p-value”.

The details of the calculation need not concern us here, except to note that it
involves assuming that the errors are normally distributed. R will provide the
p-values if we need them.

In the car fuel example, R provides the following output.

Coefficients: Estimate Std. Error t value Pr(\>|t|) (Intercept) 12.525647
0.199232 62.87 \<2e-16 \*\*\* City -0.220970 0.008878 -24.89
\<2e-16 \*\*\* --- Signif. codes: 0 \*\*\* 0.001 \*\* 0.01 \* 0.05 . 0.1 1

Residual standard error: 0.4703 on 132 degrees of freedom Multiple R-squared:
0.8244, Adjusted R-squared: 0.823 F-statistic: 619.5 on 1 and 132 DF, p-value:
\< 2.2e-16

The column headed `Pr>|t|` provides the p-values. The p-value corresponding to
the slope is in the row beginning `City` and takes value That is, it is so
small, it is less than $2\times 10^{-16} = 0.0000000000000002$. In other words,
the observed data are extremely unlikely to have arisen if the null hypothesis
were true. Therefore we reject $H_0$. It is much more likely that there is a
relationship between city fuel consumption and the carbon footprint of a car.
(Although, as we have seen, that relationship is more likely to be non-linear
than linear.)

The asterisks to the right of the p-values give a visual indication of how
small the p-values are. Three asterisks correspond to values less than 0.001,
two asterisks indicate values less than 0.01, one asterisk means the value is
less than 0.05, and so on. The legend is given in the line beginning `Signif.
codes`.

There are two other p-values provided in the above output. The p-value
corresponding to the intercept is also $<2\times 10^{-16}$; this p-value is
usually not of great interest --- it is a test on whether the intercept parameter
is zero or not. The other p-value is on the last line and, in the case of
simple linear regression, is identical to the p-value for the slope.

### Confidence intervals {-}

It is also sometimes useful to provide an interval estimate for $\beta_1$,
usually referred to as a confidence interval (and not to be confused with a
forecast or prediction interval). The interval estimate is a range of values
that probably contain $\beta_1$.

In the car fuel example, R provides the following output.

\> confint(fit,level=0.95) 2.5 (Intercept) 12.1315464 12.9197478 City
-0.2385315 -0.2034092

So if the linear model is a correct specification of the relationship between
$x$ and $y$, then the interval $[-0.239,-0.203]$ contains the slope parameter,
$\beta_1$, with probability 95%. Intervals for the intercept and for other
probability values are obtained in the same way.

There is a direct relationship between p-values and confidence intervals. If
the 95% confidence interval for $\beta_1$ does not contain 0, then the
associated p-value must be less than 0.05. More generally, if the
$100(1-\alpha)\%$ confidence interval for a parameter does not contain 0, then
the associated p-value must be less than $\alpha$.

##Non-linear functional forms {#sec-4-7-NonLinearFF}

Although the linear relationship assumed at the beginning of this chapter is
often adequate, there are cases for which a non-linear functional form is more
suitable. The scatter plot of Carbon versus City in Figure \@ref(fig-4-car) shows an
example where a non-linear functional form is required.

Simply transforming variables $y$ and/or $x$ and then estimating a regression
model using the transformed variables is the simplest way of obtaining a non-
linear specification. The most commonly used transformation is the (natural)
logarithmic (see Section \@ref(sec-2-4-TransAdj)). Recall that in order to perform a
logarithmic transformation to a variable, all its observed values must be
greater than zero.

A **log-log** functional form is specified as $$\log y_t=\beta_0+\beta_1 \log
x_t + \varepsilon_t.$$ In this model, the slope $\beta_1$ can be interpreted as
an elasticity: $\beta_1$ is the average percentage change in $y$ resulting from
a $1\%$ change in $x$.

Figure \@ref(fig-4-car-logs) shows a scatter plot of Carbon versus City and the
fitted log-log model in both the original scale and the logarithmic scale. The
plot shows that in the original scale the slope of the fitted regression line
using a log-log functional form is non-constant. The slope depends on $x$ and
can be calculated for each point (see Table \@ref(tbl-4-functionalforms)). In the
logarithmic scale the slope of the line which is now interpreted as an
elasticity is constant. So estimating a log-log functional form produces a
constant elasticity estimate in contrast to the linear model which produces a
constant slope estimate.

![Fitting a log-log functional form to the Car data example. Plots show the
estimated relationship both in the original and the logarithmic
scales.](fig_4_car_logs)

\@ref(fig-4-car-logs)

par(mfrow=c(1,2)) fit2 \<- lm(log(Carbon)   log(City), data=fuel)
plot(jitter(Carbon)   jitter(City), xlab=“City (mpg)”, ylab=“Carbon footprint
(tonnes per year)”, data=fuel) lines(1:50,
exp(fit2$coef\@ref(1)+fit2$coef\@ref(2)\*log(1:50))) plot(log(jitter(Carbon))
log(jitter(City)), xlab=“log City mpg”, ylab=“log carbon footprint”, data=fuel)
abline(fit2)

![Residual plot from estimating a log-log functional form for the Car data
example. The residuals now look much more randomly scattered compared to Figure
\@ref(fig-4-car-Res). ](fig_4_car_logsres)

\@ref(fig-4-car-logres)

res \<- residuals(fit2) plot(jitter(res, amount=.005) jitter(log(City)),
ylab=“Residuals”, xlab=“log(City)”, data=fuel)

Figure \@ref(fig-4-car-logres) shows a plot of the residuals from estimating the
log-log model. They are now randomly scatted compared to the residuals from the
linear model plotted in Figure \@ref(fig-4-car-Res). We can conclude that the log-
log functional form clearly fits the data better.

Other useful forms are the log-linear form and the linear-log form. Table
\@ref(tbl-4-functionalforms) summarises these.

\@ref(tbl-4-functionalforms) =0.4cm

<span>llll</span> Model & Functional form & Slope & Elasticity\ linear &
$y=\beta_0+\beta_1 x $ & $\beta_1$ & $\beta_1y/x$\ log-log & $\log
y=\beta_0+\beta_1 \log x$ & $\beta_1y/x$ & $\beta_1$\ linear-log &
$y=\beta_0+\beta_1 \log x $ & $\beta_1/x$ & $\beta_1/ y$\ log-linear & $\log
y=\beta_0+\beta_1 x $ & $\beta_1y$ & $\beta_1x$\

![The four non-linear forms shown in Table \@ref(tbl-4-functionalforms), for
$\beta_1<0$.](fig_4_nlforms)

##Regression with time series data {#sec-4-8-TimeSeries}

When using regression for prediction, we are often considering time series data
and we are aiming to forecast the future. There are a few issues that arise
with time series data but not with cross-sectional data that we will consider
in this section.

[US consumption expenditure]\@ref(ex-4-TSdata)

![Percentage changes in personal consumption expenditure for the
US.](fig_4_ConsInc)

\@ref(fig-4-ConsInc)

fit.ex3 \<- lm(consumption   income, data=usconsumption) plot(usconsumption,
ylab=“ plot.type=”single“, col=1:2, xlab=”Year“) legend(”topright“,
legend=c(”Consumption“,”Income“), lty=1, col=c(1,2), cex=.9) plot(consumption
income, data=usconsumption, ylab=”abline(fit.ex3) summary(fit.ex3)

Coefficients: Estimate Std. Error t value Pr(\>|t|) (Intercept) 0.52062 0.06231
8.356 2.79e-14 \*\*\* income 0.31866 0.05226 6.098 7.61e-09
\*\*\*

Figure \@ref(fig-4-ConsInc) shows time series plots of quarterly percentage changes
(growth rates) of real personal consumption expenditure ($C$) and real personal
disposable income ($I$) for the US for the period March 1970 to Dec 2010. Also
shown is a scatter plot including the estimated regression line
$$\hat{C}=0.52+0.32I,$$ with the estimation results shown below the graphs.
These show that a $1\%$ increase in personal disposable income will result to
an average increase of $0.84\%$ in personal consumption expenditure. We are
interested in forecasting consumption for the four quarters of 2011.

Using a regression model to forecast time series data poses a challenge in that
future values of the predictor variable (income in this case) are needed to be
input into the estimated model, but these are not known in advance. One
solution to this problem is to use “scenario based forecasting”.

### Scenario based forecasting {-}

In this setting the forecaster assumes possible scenarios for the predictor
variable that are of interest. For example the US policy maker may want to
forecast consumption if there is a 1% growth in income for each of the quarters
in 2011. Alternatively a 1% decline in income for each of the quarters may be
of interest. The resulting forecasts are calculated and shown in Figure
\@ref(fig-4-ConsInc2).

![Forecasting percentage changes in personal consumption expenditure for the
US.](fig_4_ConsInc2)

\@ref(fig-4-ConsInc2)

fcast \<- forecast(fit.ex3, newdata=data.frame(income=c(-1,1))) plot(fcast,
ylab="

Forecast intervals for scenario based forecasts do not include the uncertainty
associated with the future values of the predictor variables. They assume the
value of the predictor is known in advance.

An alternative approach is to use genuine forecasts for the predictor variable.
For example, a pure time series based approach can be used to generate
forecasts for the predictor variable (more on this in Chapter \@ref(ch9)) or
forecasts published by some other source such as a government agency can be
used.

### Ex {-}-ante versus ex-post forecasts

When using regression models with time series data, we need to distinguish
between two different types of forecasts that can be produced, depending on
what is assumed to be known when the forecasts are computed.

*Ex ante forecasts* are those that are made using only the information that is
available in advance. For example, ex ante forecasts of consumption for the
four quarters in 2011 should only use information that was available *before*
2011. These are the only genuine forecasts, made in advance using whatever
information is available at the time.

*Ex post forecasts* are those that are made using later information on the
predictors. For example, ex post forecasts of consumption for each of the 2011
quarters may use the actual observations of income for each of these quarters,
once these have been observed. These are not genuine forecasts, but are useful
for studying the behaviour of forecasting models.

The model from which ex-post forecasts are produced should not be estimated
using data from the forecast period. That is, ex-post forecasts can assume
knowledge of the predictor variable (the $x$ variable), but should not assume
knowledge of the data that are to be forecast (the $y$ variable).

A comparative evaluation of ex ante forecasts and ex post forecasts can help to
separate out the sources of forecast uncertainty. This will show whether
forecast errors have arisen due to poor forecasts of the predictor or due to a
poor forecasting model.

[Linear trend]\@ref(ex-4-LinTrend)

A common feature of time series data is a trend. Using regression we can model
and forecast the trend in time series data by including $t=1,\dots,T,$ as a
predictor variable: $$y_t=\beta_0+\beta_1t+\varepsilon_t.$$ Figure
\@ref(fig-4-Tourism) shows a time series plot of aggregate tourist arrivals to
Australia over the period 1980 to 2010 with the fitted linear trend line
$\hat{y}_t= 0.3375+0.1761t$. Also plotted are the point and forecast intervals
for the years 2011 to 2015.

![Forecasting international tourist arrivals to Australia for the period
2011-2015 using a linear trend. 80% and 95% forecast intervals are
shown.](fig_4_Tourism)

\@ref(fig-4-Tourism)

fit.ex4 \<- tslm(austa   trend) f \<- forecast(fit.ex4, h=5,level=c(80,95))
plot(f, ylab=“International tourist arrivals to Australia (millions)”,
xlab=“t”) lines(fitted(fit.ex4),col=“blue”) summary(fit.ex4)

Coefficients: Estimate Std. Error t value Pr(\>|t|) (Intercept) 0.337535
0.100366 3.363 0.00218 \*\* trend 0.176075 0.005475 32.157 \< 2e-16
\*\*\*

### Residual autocorrelation {-}

With time series data it is highly likely that the value of a variable observed
in the current time period will be influenced by its value in the previous
period, or even the period before that, and so on. Therefore when fitting a
regression model to time series data, it is very common to find autocorrelation
in the residuals. In this case, the estimated model violates the assumption of
no autocorrelation in the errors, and our forecasts may be inefficient --- there
is some information left over which should be utilized in order to obtain
better forecasts. The forecasts from a model with autocorrelated errors are
still unbiased, and so are not “wrong”, but they will usually have larger
prediction intervals than they need to.

Figure \@ref(fig-4-TSres) plots the residuals from Examples \@ref(ex-4-TSdata) and
\@ref(ex-4-LinTrend), and the ACFs of the residuals (see Section
\@ref(sec-2-2-NumSummaries) for an introduction to the ACF). The ACF of the
consumption residuals shows a significant spike at lag 2 and 3 and the ACF of
the tourism residuals shows significant spikes at lags 1 and 2. Usually
plotting the ACFs of the residuals is adequate to reveal any potential
autocorrelation in the residuals. More formal tests for autocorrelation are
discussed in Section \@ref(sec-dwtest).

![Residuals from the regression models for Consumption and Tourism. Because
these involved time series data, it is important to look at the ACF of the
residuals to see if there is any remaining information not accounted for by the
model. In both these examples, there is some remaining autocorrelation in the
residuals.](fig_4_TSres)

\@ref(fig-4-TSres)

par(mfrow=c(2,2)) res3 \<- ts(resid(fit.ex3),s=1970.25,f=4)
plot.ts(res3,ylab=“res (Consumption)”) abline(0,0) Acf(res3) res4 \<-
resid(fit.ex4) plot(res4,ylab=“res (Tourism)”) abline(0,0) Acf(res4)

### Spurious regression {-}

More often than not, time series data are “non-stationary”; that is, the values
of the time series do not fluctuate around a constant mean or with a constant
variance. We will deal with time series stationarity in more detail in Chapter
\@ref(ch8), but here we need to address the effect non-stationary data can have
on regression models.

![Trending time series data can appear to be related, as shown in this example
in which air passengers in Australia are regressed against rice production in
Guinea. ](fig_4_spurious)

\@ref(fig-4-spurious)

Coefficients: Estimate Std. Error t value Pr(\>|t|) (Intercept) -5.7297 0.9026
-6.348 1.9e-07 \*\*\* guinearice 37.4101 1.0487 35.672 \< 2e-16
\*\*\*

Multiple R-squared: 0.971. lag Autocorrelation 1 0.7496971

For example consider the two variables plotted in Figure \@ref(fig-4-spurious),
which appear to be related simply because they both trend upwards in the same
manner. However, air passenger traffic in Australia has nothing to do with rice
production in Guinea. Selected output obtained from regressing the number of
air passengers transported in Australia versus rice production in Guinea (in
metric tons) is also shown in Figure \@ref(fig-4-spurious).

Regressing non-stationary time series can lead to spurious regressions. High
$R^2$s and high residual autocorrelation can be signs of spurious regression.
We discuss the issues surrounding non-stationary data and spurious regressions
in detail in Chapter \@ref(ch9).

Cases of spurious regression might appear to give reasonable short-term
forecasts, but they will generally not continue to work into the future.

##Summary of notation and terminology

$x_t$ is observation $i$ on variable $x$.

$y_t=\beta_0+\beta_1x_t+\varepsilon_t$ is the **simple linear model** with
intercept $\beta_0$ and slope $\beta_1$. The error is denoted by
$\varepsilon_t$.

$y_t=\hat{\beta}_0+\hat{\beta}_1 x_t+e_t$ is the **estimated regression model**
with intercept $\hat{\beta}_0$ and slope $\hat{\beta}_1$. The estimated error
or **residual** is denoted by $e_t$.

$\hat{y}_t=\hat{\beta}_0+\hat{\beta}_1 x_t$ is the fitted or estimated
**regression line**; $\hat{y}_t$ is the **fitted value** corresponding to
observation $y_t$.

Electricity consumption was recorded for a small town on 12 randomly chosen
days. The following maximum temperatures (degrees Celsius) and consumption
(megawatt-hours) were recorded for each day.

=0.11cm

<span>@lrrrrrrrrrrrr@</span> **Day & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 &
11 & 12\ **Mwh & 16.3 & 16.8 & 15.5 & 18.2 & 15.2 & 17.5 & 19.8 & 19.0 &17.5 &
16.0 & 19.6 & 18.0\ **temp & 29.3 & 21.7 & 23.7 & 10.4 & 29.7 & 11.9 & 9.0 &
23.4 & 17.8 & 30.0 & 8.6 & 11.8\
******

[(a)]

Plot the data and find the regression model for Mwh with temperature as an
explanatory variable. Why is there a negative relationship?

Produce a residual plot. Is the model adequate? Are there any outliers or
influential observations?

Use the model to predict the electricity consumption that you would expect for
a day with maximum temperature $10^\circ$ and a day with maximum temperature
$35^\circ$. Do you believe these predictions?

Give prediction intervals for your forecasts.

The following R code will get you started:

    plot(Mwh ~ temp, data=econsumption) fit <- lm(Mwh ~ temp,
    data=econsumption) plot(residuals(fit) ~ temp, data=econsumption)
    forecast(fit, newdata=data.frame(temp=c(10,35)))

The following table gives the winning times (in seconds) for the men’s 400
meters final in each Olympic Games from 1896 to 2012 (data set `olympic`).

<span>ll|ll|ll|ll</span> 1896 & 54.2 & 1928 & 47.8 & 1964 & 45.1 & 1992 &
43.50\ 1900 & 49.4 & 1932 & 46.2 & 1968 & 43.8 & 1996 & 43.49\ 1904 & 49.2 &
1936 & 46.5 & 1972 & 44.66 &\ 1908 & 50.0 & 1948 & 46.2 & 1976 & 44.27 &\ 1912
& 48.2 & 1952 & 45.9 & 1980 & 44.60 &\ 1920 & 49.6 & 1956 & 46.7 & 1984 & 44.27
&\ 1924 & 47.6 & 1960 & 44.9 & 1988 & 43.87\

[(a)]

Update the data set `olympic` to include the winning times from the last few
Olympics.

Plot the winning time against the year. Describe the main features of the
scatterplot.

Fit a regression line to the data. Obviously the winning times have been
decreasing, but at what *average* rate per year?

Plot the residuals against the year. What does this indicate about the
suitability of the fitted line?

Predict the winning time for the men’s 400 meters final in the 2000, 2004, 2008
and 2012 Olympics. Give a prediction interval for each of your forecasts. What
assumptions have you made in these calculations?

Find out the actual winning times for these Olympics (see
[www.databaseolympics.com](www.databaseolympics.com)). How good were your
forecasts and prediction intervals?

An elasticity coefficient is the ratio of the percentage change in the forecast
variable ($y$) to the percentage change in the predictor variable ($x$).
Mathematically, the elasticity is defined as $(dy/dx)\times(x/y)$. Consider the
log-log model, $$\log y=\beta_0+\beta_1 \log x + \varepsilon.$$ Express $y$ as
a function of $x$ and show that the coefficient $\beta_1$ is the elasticity
coefficient.

