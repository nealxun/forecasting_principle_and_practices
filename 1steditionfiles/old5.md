#Multiple regression {#ch5}

In multiple regression there is one variable to be forecast and several
predictor variables. Throughout this chapter we will use two examples of
multiple regression, one based on cross-sectional data and the other on time
series data.

### Example: credit scores {-}

Banks score loan customers based on a lot of personal information. A sample of
500 customers from an Australian bank provided the following information.

<span>rrrrr</span> **Score** & **Savings** & **Income**& **Time current
address**& **Time current job**\ & **(\$’000)** & **(\$’000 )**& **(Months)**&
**(Months)**\ 39.40& 0.01& 111.17& 27& 8\ 51.79& 0.65& 56.40& 29& 33\

32.82& 0.75& 36.74& 2& 16\

57.31& 0.62& 55.99& 14& 7\

37.17& 4.13& 62.04& 2& 14\

33.69& 0.00& 43.75& 7& 7\

25.56& 0.94& 79.01& 4& 11\

32.04& 0.00& 45.41& 3& 3\

41.34& 4.26& 55.22& 16& 18\

$\vdots$& $\vdots$& $\vdots$& $\vdots$& $\vdots$\

The credit score in the left hand column is used to determine if a customer
will be given a loan or not. For these data, the score is on a scale between 0
and 100. It would save a lot of time if the credit score could be predicted
from the other variables listed above. Then there would be no need to collect
all the other information that banks require. Even if the credit score can only
be roughly forecast using these four predictors, it might provide a way of
filtering out customers that are unlikely to receive a high enough score to
obtain a loan.

This is an example of cross-sectional data where we want to predict the value
of the credit score variable using the values of the other variables.

### Example: Australian quarterly beer production {-}

Recall the Australian quarterly beer production data shown below.

![Australian quarterly beer production](beer)

\@ref(fig-5-beer)

These are time series data and we want to forecast the value of future beer
production. There are no other variables available for predictors. Instead,
with time series data, we use the number of quarters since the start of the
series as a predictor variable. We may also use the quarter of the year
corresponding to each observation as a predictor variable. Then, knowing the
number of quarters since the start of the series and the specific quarter of
interest, we can forecast the value of beer production in that quarter.

## Introduction to multiple linear regression {#sec-5-1-IntroMR}

The general form of a multiple regression is $$y_{i} = \beta_{0} + \beta_{1}
x_{1,i} + \beta_{2} x_{2,i} + \cdots + \beta_{k} x_{k,i} + \varepsilon_{i},$$
where $y_{i}$ is the variable to be forecast and $x_{1,i},\dots,x_{k,i}$ are
the $k$ predictor variables. Each of the predictor variables must be numerical.
The coefficients $\beta_{1},\dots,\beta_{k}$ measure the effect of each
predictor after taking account of the effect of all other predictors in the
model. Thus, the coefficients measure the *marginal effects* of the predictor
variables.

As for simple linear regression, when forecasting we require the following
assumptions for the errors $(\varepsilon_{1},\dots,\varepsilon_{N})$:

the errors have mean zero;

the errors are uncorrelated with each other;

the errors are uncorrelated with each predictor $x_{j,i}$.

It is also useful to have the errors normally distributed with constant
variance in order to produce prediction intervals, but this is not necessary
for forecasting.

### Example {-}: credit scores

![Scatterplot matrix of the credit scores and the four predictors.](scores1)

\@ref(fig-5-scores1)

pairs(credit[,-(4:5)],diag.panel=panel.hist) \#The panel.hist function is
defined in help(pairs).

All 500 observations of the credit score data are shown in Figure
\@ref(fig-5-scores1). The top row shows the relationship between each predictor
and credit score. While there appear to be some relationships here,
particularly between credit score and income, the predictors are all highly
skewed and the few outlying observations are making it hard to see what is
going on in the bulk of the data.

A way around this problem is to take transformations of the predictors.
However, we cannot take logarithms of the predictors because they contain some
zeros. Instead, we use the transformation $\log(x+1)$ where $x$ is the
predictor value. That is, we add one to the value of the predictor and then
take logarithms. This has a similar effect to taking logarithms but avoids the
problem of zeros. It also has the neat side-effect of zeros on the original
scale remaining zeros on the transformed scale. The scatterplot matrix showing
the transformed data is shown in Figure \@ref(fig-5-scores2).

![Scatterplot matrix of the credit scores and the four predictors, after
transforming the four predictors using logarithms.](scores2)

\@ref(fig-5-scores2)

creditlog \<- data.frame(score=credit$score, log.savings=log(credit$savings+1),
  log.income=log(credit$income+1), log.address=log(credit$time.address+1),
  log.employed=log(credit$time.employed+1), fte=credit$fte,
  single=credit$single) pairs(creditlog[,1:5],diag.panel=panel.hist)
\end{Rcode}
\end{figure}

Now the relationships between the variables are clearer, although there is a
great deal of random variation present. We shall try fitting the following
model:
\[
y = \beta_{0} + \beta_{1}x_{1} + \beta_{2}x_{2} + \beta_3x_3 + \beta_4x_4 +
\varepsilon,
\]
where\vspace*{-0.85cm}
\begin{align*}
y     & =  \text{credit score},         \\ x_{1} & =  \text{log savings}, \\
x_{2} & =  \text{log income},      \\ x_{3} & =  \text{log time at current
address},\\ x_4   &=  \text{log time in current job},\\
\varepsilon     & =  \text{error}.
\end{align*}
Here "" means the transformation $(x+1)$.

### Estimation of the model {-}

The values of the coefficients $~0~,…,~k~$ are obtained by finding the minimum
sum of squares of the errors. That is, we find the values of $~0~,…,~k~$ which
minimize
\[
\sum_{i=1}^N \varepsilon_{i}^2 = \sum_{i=1}^N (y_{i} - \beta_{0} - \beta_{1}x_{1,i} - \cdots - \beta_{k} x_{k,i})^2.
\]
This is called "least squares" estimation because it gives the least value for
the sum of squared errors. In practice, the calculation is always done using a
computer package. Finding the best estimates of the coefficients is often
called "fitting" the model to the data.

When we refer to the \emph{estimated} coefficients, we will use the notation
$~0~,…,~k~$. The equations for these will be given in
Section~\ref{sec-5-5-Matrix}.

\subsection{Example: credit scores (continued)}
The following computer output is obtained after fitting the regression model
described earlier.
\begin{Rcode}
fit <- lm(score ~ log.savings + log.income + log.address
  + log.employed + single, data=creditlog) summary(fit)
\end{Rcode}
\begin{Routput}
Coefficients: Estimate Std. Error t value  P value (Intercept)    -0.219
             5.231   -0.04   0.9667 log.savings    10.353      0.612   16.90  <
             2e-16 log.income      5.052      1.258    4.02  6.8e-05
             log.address     2.667      0.434    6.14  1.7e-09 log.employed
             1.314      0.409    3.21   0.0014

Residual standard error: 10.16 on 495 degrees of freedom Multiple R-squared:
0.4701, Adjusted R-squared: 0.4658 F-statistic: 109.8 on 4 and 495 DF,
p-value: < 2.2e-16
\end{Routput}
The first column gives the estimates of each ?? coefficient and the second
column gives its "standard error" (i.e., the standard deviation which would be
obtained from repeatedly estimating the ?? coefficients on similar data sets).
The standard error gives a measure of the uncertainty in the estimated ??
coefficient.

For forecasting purposes, the final two columns are of limited interest. The "t
value" is the ratio of a  ?? to its standard error and the last column gives
the p-value: the probability of the estimated ?? coefficient being as large as
it is if there was no real relationship between the credit score and the
predictor. This is useful when studying the effect of each predictor, but is
not particularly useful when forecasting.

## Fitted values, forecast values and residuals {-}

Predictions of $y$ can be calculated by ignoring the error in the regression
equation. That is
\[
\hat{y} = \hat\beta_{0} + \hat\beta_{1} x_{1} + \hat\beta_{2} x_{2} + \cdots + \hat\beta_{k} x_{k}.
\]
Plugging in values of $x~1~,…,x~k~$ into the right hand side of this equation
gives a prediction of $y$ for that combination of predictors.

When this calculation is done using values of the predictors from the data that
were used to estimate the model, we call the resulting values of ?? the "fitted
values". These are "predictions" of the data used in estimating the model. They
are not genuine forecasts as the actual value of $y$ for that set of predictors
was used in estimating the model, and so the value of ?? is affected by the
true value of $y$.

When the values of $x~1~,…,x~k~$ are new values (i.e., not part of the data
that were used to estimate the model), the resulting value of ?? is a genuine
forecast.

The difference between the $y$ observations and the fitted values are the
"residuals":
\[
e_i = y_i - \hat{y}_i = y_i - \hat\beta_{0} - \hat\beta_{1} x_{1,i} -
\hat\beta_{2} x_{2,i} - \cdots - \hat\beta_{k} x_{k,i}.
\]
As with simple regression (see Section~\ref{sec-4-2-LSprinciple}), the
residuals have zero mean and are uncorrelated with any of the predictors.

\subsection{R$^2^$: the coefficient of determination}

The $R^2^$ value was introduced in Section~\ref{sec-4-4-EvaluatingSLR}. It is
the square of the correlation between the actual values and the predicted
values. The following graph shows the actual values plotted against the fitted
values for the credit score data.

\begin{figure}
\centering\includegraphics[width=\textwidth]{scores3}
\caption{Actual credit scores plotted against fitted credit scores using the multiple regression model. The correlation is 0.6856, so the squared correlation is $(0.6856)^2^=0.4701$.}\label{fig-5-scores3}
\begin{Rcode}
plot(fitted(fit), creditlog$score, ylab=“Score”, xlab=“Predicted score”)

Recall that the value of $R^2$ can also be calculated as the proportion of
variation in the forecast variable that is explained by the regression model:
$$R^2 = \frac{\sum(\hat{y}_{i} - \bar{y})^2}{\sum(y_{i}-\bar{y})^2}$$ In this
case, $R^2=0.47$, so about half of the variation in the scores can be predicted
using the model.

Thus, the model is not really sufficient to replace a more detailed approach to
credit scoring, but it might be helpful in filtering out customers who will get
a very low score. In the above graph it is evident that anyone with a predicted
score below 35 has a true score not much more than 60. Consequently, if the
bank wanted to identify high scoring customers quickly, using this model will
provide a first filter, and more detailed information need only be collected on
a subset of the customers.

##Some useful predictors {#sec-5-2-UsefulPredictors}

### Dummy variables {-}

So far, we have assumed that each predictor takes numerical values. But what
about when a predictor is a categorical variable taking only two values (e.g.,
“yes” and “no”). Such a variable might arise, for example, when forecasting
credit scores and you want to take account of whether the customer is in full-
type employment. So the predictor takes value “yes” when the customer is in
full-time employment, and “no” otherwise.

This situation can still be handled within the framework of multiple regression
models by creating a “dummy variable” taking value 1 corresponding to “yes” and
0 corresponding to “no”. A dummy variable is also known as an “indicator
variable”.

If there are more than two categories, then the variable can be coded using
several dummy variables (one fewer than the total number of categories).

#### Seasonal dummy variables

For example, suppose we are forecasting daily electricity demand and we want to
account for the day of the week as a predictor. Then the following dummy
variables can be created.

<span>lccccccc</span> Day & D1 & D2 & D3 & D4 & D5 & D6 &\ Monday & 1 & 0 & 0 &
0 & 0 & 0 &\ Tuesday & 0 & 1 & 0 & 0 & 0 & 0 &\ Wednesday & 0 & 0 & 1 & 0 & 0 &
0 &\ Thursday & 0 & 0 & 0 & 1 & 0 & 0 &\ Friday & 0 & 0 & 0 & 0 & 1 & 0 &\
Saturday & 0 & 0 & 0 & 0 & 0 & 1 &\ Sunday & 0 & 0 & 0 & 0 & 0 & 0 &\ Monday &
1 & 0 & 0 & 0 & 0 & 0 &\ Tuesday & 0 & 1 & 0 & 0 & 0 & 0 &\ Wednesday & 0 & 0 &
1 & 0 & 0 & 0 &\ Thursday & 0 & 0 & 0 & 1 & 0 & 0 &\ $\vdots$ & $\vdots$ &
$\vdots$ & $\vdots$ & $\vdots$ & $\vdots$ & $\vdots$ &\ &\

Notice that only six dummy variables are needed to code seven categories. That
is because the seventh category (in this case Sunday) is specified when the
dummy variables are all set to zero.

Many beginners will try to add a seventh dummy variable for the seventh
category. This is known as the “dummy variable trap” because it will cause the
regression to fail. There will be too many parameters to estimate. The general
rule is to use one fewer dummy variables than categories. So for quarterly
data, use three dummy variables; for monthly data, use 11 dummy variables; and
for daily data, use six dummy variables.

The interpretation of each of the coefficients associated with the dummy
variables is that it is *a measure of the effect of that category relative to
the omitted category*. In the above example, the coefficient associated with
Monday will measure the effect of Monday compared to Sunday on the forecast
variable.

#### Outliers

If there is an outlier in the data, rather than omit it, you can use a dummy
variable to remove its effect. In this case, the dummy variable takes value one
for that observation and zero everywhere else.

#### Public holidays

For daily data, the effect of public holidays can be accounted for by including
a dummy variable predictor taking value one on public holidays and zero
elsewhere.

#### Easter

Easter is different from most holidays because it is not held on the same date
each year and the effect can last for several days. In this case, a dummy
variable can be used with value one where any part of the holiday falls in the
particular time period and zero otherwise.

For example, with monthly data, when Easter falls in March then the dummy
variable takes value 1 in March, when it falls in April, the dummy variable
takes value 1 in April, and when it starts in March and finishes in April, the
dummy variable takes value 1 for both months.

### Trend {-}

A linear trend is easily accounted for by including the predictor $x_{1,t}=t$.
A quadratic or higher order trend is obtained by specifying $$x_{1,t} =t,\quad
x_{2,t}=t^2,\quad \dots$$ However, it is not recommended that quadratic or
higher order trends are used in forecasting. When they are extrapolated, the
resulting forecasts are often very unrealistic.

A better approach is to use a piecewise linear trend which bends at some time.
If the trend bends at time $\tau$, then it can be specified by including the
following predictors in the model.

$$\begin{aligned} x_{1,t} & = t \\ x_{2,t} &= \left\{ \begin{array}{ll} 0 & t <
\tau\\ (t-\tau) &  t \ge \tau
\end{array}\right.\end{aligned}$$

If the associated coefficients of $x_{1,t}$ and $x_{2,t}$ are $\beta_1$ and
$\beta_2$, then $\beta_1$ gives the slope of the trend before time $\tau$,
while the slope of the line after time $\tau$ is given by $\beta_1+\beta_2$.

An extension of this idea is to use a spline (see Section
\@ref(sec-5-6-NonLinear)).

### Ex {-} post and ex ante forecasting

As discussed in Section \@ref(sec-4-8-TimeSeries), ex ante forecasts are those
that are made using only the information that is available in advance, while ex
post forecasts are those that are made using later information on the
predictors.

Normally, we cannot use future values of the predictor variables when producing
ex ante forecasts because their values will not be known in advance. However,
the special predictors introduced in this section are all known in advance, as
they are based on calendar variables (e.g., seasonal dummy variables or public
holiday indicators) or deterministic functions of time. In such cases, there is
no difference betweeen ex ante and ex post forecasts.

### Example {-}: Australian quarterly beer production

We can model the Australian beer production data using a regression model with
a linear trend and quarterly dummy variables: $$y_{t} = \beta_{0} + \beta_{1} t
+ \beta_{2}d_{2,t} + \beta_3 d_{3,t} + \beta_4 d_{4,t} + \varepsilon_{t},$$
where $d_{i,t} = 1$ if $t$ is in quarter $i$ and 0 otherwise. The first quarter
variable has been omitted, so the coefficients associated with the other
quarters are measures of the difference between those quarters and the first
quarter.

Computer output from this model is given below.

beer2 \<- window(ausbeer,start=1992,end=2006-.1) fit \<- tslm(beer2 trend +
season) summary(fit)

Coefficients: Estimate Std. Error t value Pr(\>|t|) (Intercept) 441.8141 4.5338
97.449 \< 2e-16 trend -0.3820 0.1078 -3.544 0.000854 season2 -34.0466 4.9174
-6.924 7.18e-09 season3 -18.0931 4.9209 -3.677 0.000568 season4 76.0746 4.9268
15.441 \< 2e-16

Residual standard error: 13.01 on 51 degrees of freedom Multiple R-squared:
0.921, Adjusted R-squared: 0.9149

So there is a strong downward trend of 0.382 megalitres per quarter. On
average, the second quarter has production of 34.0 megalitres lower than the
first quarter, the third quarter has production of 18.1 megalitres lower than
the first quarter, and the fourth quarter has production 76.1 megalitres higher
than the first quarter. The model explains 92.1% of the variation in the beer
production data.

The following plots show the actual values compared to the predicted (i.e.,
fitted) values.

![Time plot of beer production and predicted beer production.](beerlm2)

\@ref(fig-5-beerlm2)

plot(beer2, xlab=“Year”, ylab=“”, main=“Quarterly Beer Production”)
lines(fitted(fit), col=2) legend(“topright”, lty=1, col=c(1,2), legend =
c(“Actual”,“Predicted”))

![Actual beer production plotted against predicted beer production.](beerlm3)

\@ref(fig-5-beerlm3)

plot(fitted(fit), beer2, xy.lines = FALSE, xy.labels = FALSE, xlab=“Predicted
values”, ylab=“Actual values”, main=“Quarterly Beer Production”) abline(0, 1,
col=“gray”)

![Forecasts from the regression model for beer production. The dark shaded
region shows 80% prediction intervals and the light shaded region shows 95%
prediction intervals.](beerlm1)

\@ref(fig-5-beerlm1)

fcast \<- forecast(fit) plot(fcast, main=“Forecasts of beer production using
linear regression”)

Forecasts obtained from the model are shown in Figure \@ref(fig-5-beerlm1).

### Intervention variables {-}

It is often necessary to model interventions that may have affected the
variable to be forecast. For example, competitor activity, advertising
expenditure, industrial action, and so on, can all have an effect.

When the effect lasts only for one period, we use a spike variable. This is a
dummy variable taking value one in the period of the intervention and zero
elsewhere. A spike variable is equivalent to a dummy variable for handling an
outlier.

Other interventions have an immediate and permanent effect. If an intervention
causes a level shift (i.e., the value of the series changes suddenly and
permanently from the time of intervention), then we use a step variable. A step
variable takes value zero before the intervention and one from the time of
intervention onwards.

Another form of permanent effect is a change of slope. Here the intervention is
handled using a piecewise linear trend as discussed earlier (where $\tau$ is
the time of intervention).

### Trading days {-}

The number of trading days in a month can vary considerably and can have a
substantial effect on sales data. To allow for this, the number of trading days
in each month can be included as a predictor. An alternative that allows for
the effects of different days of the week has the following predictors:

$$\begin{aligned} x_{1} &= \text{\# Mondays in month;} \\ x_{2} &= \text{\#
Tuesdays in month;} \\ & \vdots \\ x_{7} &= \text{\# Sundays in
month.}\end{aligned}$$

### Distributed lags {-}

It is often useful to include advertising expenditure as a predictor. However,
since the effect of advertising can last beyond the actual campaign, we need to
include lagged values of advertising expenditure. So the following predictors
may be used.

$$\begin{aligned} x_{1} &= \text{advertising for previous month;} \\ x_{2} &=
\text{advertising for two months previously;} \\ &\vdots \\ x_{m} &=
\text{advertising for $m$ months previously.}\end{aligned}$$

It is common to require the coefficients to decrease as the lag increases. In
Chapter \@ref(ch9) we discuss methods to allow this constraint to be
implemented.

##Selecting predictors {#sec-5-3-SelectingPredictors}


When there are many possible predictors, we need some strategy to select the
best predictors to use in a regression model.

A common approach that is *not recommended* is to plot the forecast variable
against a particular predictor and if it shows no noticeable relationship, drop
it. This is invalid because it is not always possible to see the relationship
from a scatterplot, especially when the effect of other predictors has not been
accounted for.

Another common approach which is also invalid is to do a multiple linear
regression on all the predictors and disregard all variables whose $p$-values
are greater than 0.05. To start with, statistical significance does not always
indicate predictive value. Even if forecasting is not the goal, this is not a
good strategy because the $p$-values can be misleading when two or more
predictors are correlated with each other (see Section
\@ref(sec-5-8-MultiCol)).

Instead, we will use a measure of predictive accuracy. Five such measures are
introduced in this section.

### Adjusted R {-}$^2$

Computer output for regression will always give the $R^2$ value, discussed in
Section \@ref(sec-5-1-IntroMR). However, it is not a good measure of the
predictive ability of a model. Imagine a model which produces forecasts that
are exactly 20% of the actual values. In that case, the $R^2$ value would be 1
(indicating perfect correlation), but the forecasts are not very close to the
actual values.

In addition, $R^2$ does not allow for “degrees of freedom”. Adding *any*
variable tends to increase the value of $R^2$, even if that variable is
irrelevant. For these reasons, forecasters should not use $R^2$ to determine
whether a model will give good predictions.

An equivalent idea is to select the model which gives the minimum sum of
squared errors (SSE), given by $$\text{SSE} = \sum_{i=1}^N e_{i}^2.$$

Minimizing the SSE is equivalent to maximizing $R^2$ and will always choose the
model with the most variables, and so is not a valid way of selecting
predictors.

An alternative, designed to overcome these problems, is the adjusted $R^2$
(also called “R-bar-squared”): $$\bar{R}^2 = 1-(1-R^2)\frac{N-1}{N-k-1},$$
where $N$ is the number of observations and $k$ is the number of predictors.
This is an improvement on $R^2$ as it will no longer increase with each added
predictor. Using this measure, the best model will be the one with the largest
value of $\bar{R}^2$.

Maximizing $\bar{R}^2$ is equivalent to minimizing the following estimate of
the variance of the forecast errors: $$\hat{\sigma}^2 =
\frac{\text{SSE}}{N-k-1}.$$

Maximizing $\bar{R}^2$ works quite well as a method of selecting predictors,
although it does tend to err on the side of selecting too many predictors.

### Cross {-}-validation

As discussed in Section \@ref(sec-2-5-Accuracy), cross-validation is a very
useful way of determining the predictive ability of a model. In general, leave-
one-out cross-validation for regression can be carried out using the following
steps.

Remove observation $i$ from the data set, and fit the model using the remaining
data. Then compute the error ($e_{i}^*=y_{i}-\hat{y}_{i}$) for the omitted
observation. (This is not the same as the residual because the $i$th
observation was not used in estimating the value of $\hat{y}_{i}$.)

Repeat step 1 for $i=1,\dots,N$.

Compute the MSE from $e_{1}^*,\dots,e_{N}^*$. We shall call this the CV.

For many forecasting models, this is a time-consuming procedure, but for
regression there are very fast methods of calculating CV so it takes no longer
than fitting one model to the full data set. The equation for computing CV is
given in Section \@ref(sec-5-5-Matrix).

Under this criterion, the best model is the one with the smallest value of CV.

### Akaike {-}’s Information Criterion

A closely-related method is Akaike’s Information Criterion, which we define as
$$\text{AIC} = N\log\left(\frac{\text{SSE}}{N}\right) + 2(k+2),$$ where $N$ is
the number of observations used for estimation and $k$ is the number of
predictors in the model. Different computer packages use slightly different
definitions for the AIC, although they should all lead to the same model being
selected. The $k+2$ part of the equation occurs because there are $k+2$
parameters in the model --- the $k$ coefficients for the predictors, the
intercept and the variance of the residuals. The idea here is to penalize the
fit of the model (SSE) with the number of parameters that need to be estimated.

The model with the minimum value of the AIC is often the best model for
forecasting. For large values of $N$, minimizing the AIC is equivalent to
minimizing the CV value.

### Corrected Akaike {-}’s Information Criterion

For small values of $N$, the AIC tends to select too many predictors, and so a
bias-corrected version of the AIC has been developed. $$\text{AIC}_{\text{c}} =
\text{AIC} + \frac{2(k+2)(k+3)}{N-k-3}.$$ As with the AIC, the AIC$_\text{c}$
should be minimized.

### Schwarz Bayesian Information Criterion {-}

A related measure is Schwarz’s Bayesian Information Criterion (known as SBIC,
BIC or SC): $$\text{BIC} = N\log\left(\frac{\text{SSE}}{N}\right) +
(k+2)\log(N).$$ As with the AIC, minimizing the BIC is intended to give the
best model. The model chosen by BIC is either the same as that chosen by AIC,
or one with fewer terms. This is because the BIC penalizes the number of
parameters more heavily than the AIC. For large values of $N$, minimizing BIC
is similar to leave-$v$-out cross-validation when $v = N[1-1/(\log(N)-1)]$.

Many statisticians like to use BIC because it has the feature that if there is
a true underlying model, then with enough data the BIC will select that model.
However, in reality there is rarely if ever a true underlying model, and even
if there was a true underlying model, selecting that model will not necessarily
give the best forecasts (because the parameter estimates may not be accurate).

\# To obtain all these measures in R, use CV(fit)

### Example {-}: credit scores (continued)

In the credit scores regression model we used four predictors. Now we can check
if all four predictors are actually useful, or whether we can drop one or more
of them. With four predictors, there are $2^4=16$ possible models. All 16
models were fitted, and the results are summarized in the table below.

<span>llllllllll</span> **Savings& **Income& **Address& **Employ.& **CV& **AIC&
**AIC$_\text{c}$& **BIC& **Adj R$^2$&\ X& X& X& X& 104.7& 2325.8& 2325.9&
2351.1& 0.4658&\ X& X& X& & 106.5& 2334.1& 2334.2& 2355.1& 0.4558&\ X& & X& X&
107.7& 2339.8& 2339.9& 2360.9& 0.4495&\ X& & X& & 109.7& 2349.3& 2349.3&
2366.1& 0.4379&\ X& X& & X& 112.2& 2360.4& 2360.6& 2381.5& 0.4263&\ X& & & X&
115.1& 2373.4& 2373.5& 2390.3& 0.4101&\ X& X& & & 116.1& 2377.7& 2377.8&
2394.6& 0.4050&\ X& & & & 119.5& 2392.1& 2392.2& 2404.8& 0.3864&\ & X& X& X&
164.2& 2551.6& 2551.7& 2572.7& 0.1592&\ & X& X& & 164.9& 2553.8& 2553.9&
2570.7& 0.1538&\ & X& & X& 176.1& 2586.7& 2586.8& 2603.6& 0.0963&\ & & X& X&
177.5& 2591.4& 2591.5& 2608.3& 0.0877&\ & & X& & 178.6& 2594.6& 2594.6& 2607.2&
0.0801&\ & X& & & 179.1& 2595.3& 2595.3& 2607.9& 0.0788&\ & & & X& 190.0&
2625.3& 2625.4& 2638.0& 0.0217&\ & & & & 193.8& 2635.3& 2635.3& 2643.7&
0.0000&\
******************

An X indicates that the variable was included in the model. The best models are
given at the top of the table, and the worst models are at the bottom of the
table.

The model with all four predictors has the lowest CV, AIC, AIC$_\text{c}$ and
BIC values and the highest $\bar{R}^2$ value. So in this case, all the measures
of predictive accuracy indicate the same “best” model which is the one that
includes all four predictors. The different measures do not always lead to the
same model being selected.

### Best subset regression {-}

Where possible, all potential regression models can be fitted (as was done in
the above example) and the best one selected based on one of the measures
discussed here. This is known as “best subsets” regression or “all possible
subsets” regression.

It is recommended that one of CV, AIC or AIC$_\text{c}$ be used for this
purpose. If the value of $N$ is large enough, they will all lead to the same
model. Most software packages will at least produce AIC, although CV and
AIC$_\text{c}$ will be more accurate for smaller values of $N$.

While $\bar{R}^2$ is very widely used, and has been around longer than the
other measures, its tendency to select too many predictor variables makes it
less suitable for forecasting than either CV, AIC or AIC$_\text{c}$. Also, the
tendency of BIC to select too few variables makes it less suitable for
forecasting than either CV, AIC or AIC$_\text{c}$.

### Stepwise regression {-}

If there are a large number of predictors, it is not possible to fit all
possible models. For example, 40 predictors leads to $2^{40} >$ 1 trillion
possible models! Consequently, a strategy is required to limit the number of
models to be explored.

An approach that works quite well is *backwards stepwise regression*:

Start with the model containing all potential predictors.

Try subtracting one predictor at a time. Keep the model if it improves the
measure of predictive accuracy.

Iterate until no further improvement.

It is important to realise that a stepwise approach is not guaranteed to lead
to the best possible model. But it almost always leads to a good model.

If the number of potential predictors is too large, then this backwards
stepwise regression will not work and the starting model will need to use only
a subset of potential predictors. In this case, an extra step needs to be
inserted in which predictors are also added one at a time, with the model being
retained if it improves the measure of predictive accuracy.

##Residual diagnostics {#sec-5-4-ResDiagnostics}


\@ref(sec-dwtest)

The residuals from a regression model are calculated as the difference between
the actual values and the fitted values: $e_{i} = y_{i}-\hat{y}_{i}$. Each
residual is the unpredictable component of the associated observation.

After selecting the regression variables and fitting a regression model, it is
necessary to plot the residuals to check that the assumptions of the model have
been satisfied. There are a series of plots that should be produced in order to
check different aspects of the fitted model and the underlying assumptions.

### Scatterplots of residuals against predictors {-}

Do a scatterplot of the residuals against each predictor in the model. If these
scatterplots show a pattern, then the relationship may be nonlinear and the
model will need to be modified accordingly. See Section
\@ref(sec-5-6-NonLinear) for a discussion of nonlinear regression.

![The residuals from the regression model for credit scores plotted against
each of the predictors in the model.](scores4)

\@ref(fig-5-scores4)

fit \<- lm(score   log.savings + log.income + log.address + log.employed,
data=creditlog) par(mfrow=c(2,2))
plot(creditlog$log.savings,residuals(fit),xlab="log(savings)")
plot(creditlog$log.income,residuals(fit),xlab=“log(income)”)
plot(creditlog$log.address,residuals(fit),xlab="log(address)")
plot(creditlog$log.employed,residuals(fit),xlab=“log(employed)”)

It is also necessary to plot the residuals against any predictors *not* in the
model. If these show a pattern, then the predictor may need to be added to the
model (possibly in a nonlinear form).

Figure \@ref(fig-5-scores4) shows the residuals from the model fitted to credit
scores. In this case, the scatterplots show no obvious patterns, although the
residuals tend to be negative for large values of the savings predictor. This
suggests that the credit scores tend to be over-estimated for people with large
amounts of savings. To correct this bias, we would need to use a non-linear
model (see Section \@ref(sec-5-6-NonLinear)).

### Scatterplot of residuals against fitted values {-}

A plot of the residuals against the fitted values should show no pattern. If a
pattern is observed, there may be “heteroscedasticity” in the errors. That is,
the variance of the residuals may not be constant. To overcome this problem, a
transformation of the forecast variable (such as a logarithm or square root)
may be required.

Figure \@ref(fig-5-scores5) shows a plot of the residuals against the fitted
values for the credit score model.

![The residuals from the credit score model plotted against the fitted values
obtained from the model.](scores5)

\@ref(fig-5-scores5)

plot(fitted(fit), residuals(fit), xlab=“Predicted scores”, ylab=“Residuals”)

Again, the plot shows no systematic patterns and the variation in the residuals
does not seem to change with the size of the fitted value.

### Autocorrelation in the residuals {-}

When the data are a time series, you should look at an ACF plot of the
residuals. This will reveal if there is any autocorrelation in the residuals
(suggesting that there is information that has not been accounted for in the
model).

Figure \@ref(fig-5-beerlm4) shows a time plot and ACF of the residuals from the
model fitted to the beer production data discussed in Section
\@ref(sec-5-2-UsefulPredictors).

![Residuals from the regression model for beer production.](beerlm4)

\@ref(fig-5-beerlm4)

fit \<- tslm(beer2   trend + season) res \<- residuals(fit) par(mfrow=c(1,2))
plot(res, ylab=“Residuals”,xlab=“Year”) Acf(res, main=“ACF of residuals”)

There is an outlier in the residuals (2004:Q4) which suggests there was
something unusual happening in that quarter. It would be worth investigating
that outlier to see if there were any unusual circumstances or events that may
have reduced beer production for the quarter.

The remaining residuals show that the model has captured the patterns in the
data quite well, although there is a small amount of autocorrelation left in
the residuals (seen in the significant spike in the ACF plot). This suggests
that the model can be slightly improved, although it is unlikely to make much
difference to the resulting forecasts.

Another test of autocorrelation that is designed to take account of the
regression model is the **Durbin-Watson** test. It is used to test the
hypothesis that there is no lag one autocorrelation in the residuals. If there
is no autocorrelation, the Durbin-Watson distribution is symmetric around 2.
Most computer packages will report the DW statistic automatically, and should
also provide a p-value. A small p-value indicates there is significant
autocorrelation remaining in the residuals. For the beer model, the Durbin-
Watson test reveals some significant lag one autocorrelation.

dwtest(fit, alt=“two.sided”) \# It is recommended that the two-sided test
always be used \# to check for negative as well as positive autocorrelation

Durbin-Watson test DW = 2.5951, p-value = 0.02764

Both the ACF plot and the Durbin-Watson test show that there is some
autocorrelation remaining in the residuals. This means there is some
information remaining in the residuals that can be exploited to obtain better
forecasts. The forecasts from the current model are still unbiased, but will
have larger prediction intervals than they need to. A better model in this case
will be a dynamic-regression model which will be covered in Chapter \@ref(ch9).

A third possible test is the **Breusch-Godfrey** test designed to look for
significant higher-lag autocorrelations.

\# Test for autocorrelations up to lag 5. bgtest(fit,5)

### Histogram of residuals {-}

Finally, it is a good idea to check if the residuals are normally distributed.
As explained earlier, this is not essential for forecasting, but it does make
the calculation of prediction intervals much easier.

![Histogram of residuals from regression model for beer production.](beerlm5)

\@ref(fig-5-beerlm5)

hist(res, breaks=“FD”, xlab=“Residuals”, main=“Histogram of residuals”,
ylim=c(0,22)) x \<- -50:50 lines(x, 560\*dnorm(x,0,sd(res)),col=2)

In this case, the residuals seem to be slightly negatively skewed, although
that is probably due to the outlier.

##Matrix formulation {#sec-5-5-Matrix}

*Warning: this is a more advanced optional section and assumes knowledge of
matrix algebra.*

The multiple regression model can be written as $$y_{i} = \beta_{0} + \beta_{1}
x_{1,i} + \beta_{2} x_{2,i} + \cdots + \beta_{k} x_{k,i} + \varepsilon_{i}.$$

This expresses the relationship between a single value of the forecast variable
and the predictors. It can be convenient to write this in matrix form where all
the values of the forecast variable are given in a single equation. Let 
$\bm{y} = (y_{1},\dots,y_{N})'$, 
$\bm{\varepsilon} = (\varepsilon_{1},\dots,\varepsilon_{N})'$, 
$\bm{\beta} = (\beta_{0},\dots,\beta_{k})'$ and
$$
\bm{X} = \left[\begin{matrix}
  1 & x_{1,1} & x_{2,1} & \dots & x_{k,1}\\ 
  1 & x_{1,2} & x_{2,2} & \dots & x_{k,2}\\
  \vdots& \vdots& \vdots&& \vdots\\
  1 & x_{1,N}& x_{2,N}& \dots& x_{k,N}
\end{matrix}\right].
$$ 
Then
$$\bm{y} = \bm{X}\bm{\beta} + \bm{\varepsilon}.$$

### Least squares estimation {-}

Least squares estimation is obtained by minimizing the expression
$\bm{\varepsilon}'\bm{\varepsilon} = (\bm{Y} - \bm{X}\bm{\beta})'(\bm{Y} -
\bm{X}\bm{\beta})$. It can be shown that this is minimized when $\bm{\beta}$
takes the value 
$$\hat{\bm{\beta}} = (\bm{X}'\bm{X})^{-1}\bm{X}'\bm{Y}$$ 
This is sometimes known as the “normal equation”. The estimated coefficients
require the inversion of the matrix $\bm{X}'\bm{X}$. If this matrix is
singular, then the model cannot be estimated. This will occur, for example, if
you fall for the “dummy variable trap” (having the same number of dummy
variables as there are categories of a categorical predictor).

The residual variance is estimated using $$\hat{\sigma}^2 =
\frac{1}{N-k-1}(\bm{Y} - \bm{X}\hat{\bm{\beta}})'(\bm{Y} -
\bm{X}\hat{\bm{\beta}}).$$

### Fitted values and cross {-}-validation

The normal equation shows that the fitted values can be calculated using
$$\bm{\hat{Y}} = \bm{X}\hat{\bm{\beta}} =
\bm{X}(\bm{X}'\bm{X})^{-1}\bm{X}'\bm{Y} = \bm{H}\bm{Y},$$ where $\bm{H} =
\bm{X}(\bm{X}'\bm{X})^{-1}\bm{X}'$ is known as the “hat-matrix” because it is
used to compute $\bm{\hat{Y}}$ (“Y-hat”).

If the diagonal values of $\bm{H}$ are denoted by $h_{1},\dots,h_{N}$, then the
cross-validation statistic can be computed using $$\text{CV} =
\frac{1}{N}\sum_{i=1}^N [e_{i}/(1-h_{i})]^2,$$ where $e_{i}$ is the residual
obtained from fitting the model to all $N$ observations. Thus, it is not
necessary to actually fit $N$ separate models when computing the CV statistic.

### Forecasts {-}

Let $\bm{X}^*$ be a row vector containing the values of the predictors for the
forecasts (in the same format as $\bm{X}$). Then the forecast is given by
$$\hat{y} = \bm{X}^*\hat{\bm{\beta}} =
\bm{X}^*(\bm{X}'\bm{X})^{-1}\bm{X}'\bm{Y}$$ and its variance by $$\sigma^2
\left[1 + \bm{X}^* (\bm{X}'\bm{X})^{-1} (\bm{X}^*)'\right].$$ Then a 95%
prediction interval can be calculated (assuming normally distributed errors) as
$$\hat{y} \pm 1.96 \hat{\sigma} \sqrt{1 + \bm{X}^* (\bm{X}'\bm{X})^{-1}
(\bm{X}^*)'}.$$ This takes account of the uncertainty due to the error term
$\varepsilon$ and the uncertainty in the coefficient estimates. However, it
ignores any errors in $\bm{X}^*$. So if the future values of the predictors are
uncertain, then the prediction interval calculated using this expression will
be too narrow.

##Non-linear regression {#sec-5-6-NonLinear}


Sometimes the relationship between the forecast variable and a predictor is not
linear, and then the usual multiple regression equation needs modifying. In
Section \@ref(sec-4-7-NonLinearFF), we discussed using log transformations to
deal with a variety of non-linear forms, and in Section
\@ref(sec-5-2-UsefulPredictors) we showed how to include a piecewise-linear
trend in a model; that is a nonlinear trend constructed out of linear pieces.
Allowing other variables to enter in a nonlinear manner can be handled in
exactly the same way.

To keep things simple, suppose we have only one predictor $x$. Then the model
we use is $$y = f(x) + e,$$ where $f$ is a possibly nonlinear function. In
standard (linear) regression, $f(x)=\beta_{0} + \beta_{1} x$, but in nonlinear
regression, we allow $f$ to be a nonlinear function of $x$.

One of the simplest ways to do nonlinear regression is to make $f$ piecewise
linear. That is, we introduce points where the slope of $f$ can change. These
points are called “knots”.

[Car emissions continued] In Chapter \@ref(ch4), we considered an example of
forecasting the carbon footprint of a car from its city-based fuel economy. Our
previous analysis (Section \@ref(sec-4-7-NonLinearFF)) showed that this
relationship was nonlinear. Close inspection of Figure \@ref(fig-4-car)
suggests that a change in slope occurs at about 25mpg. This can be achieved
using the following variables: $x$ (the City mpg) and $$z = (x-25)_+ =
\left\{\begin{array}{ll} 0 & \text{if $x<25$}\\ x-25 & \text{if $x\ge
25$}.\end{array}\right.$$ The resulting fitted values are shown as the red line
below.

![Piecewise linear trend to fuel economy data.](nlcarbon1)

\@ref(fig-5-nlpulp2)

Cityp \<- pmax(fuel$City-25,0) fit2 <- lm(Carbon ~ City + Cityp, data=fuel) x
<- 15:50; z <- pmax(x-25,0) fcast2 <- forecast(fit2,
newdata=data.frame(City=x,Cityp=z)) plot(jitter(Carbon) ~ jitter(City),
data=fuel) lines(x, fcast2$mean,col=“red”)

Additional bends can be included in the relationship by adding further
variables of the form $(x-c)_+$ where $c$ is the “knot” or point at which the
line should bend. As above, the notation $(x-c)_+$ means the value $x-c$ if it
is positive and 0 otherwise.

### Regression splines {-}

Piecewise linear relationships constructed in this way are a special case of
*regression splines*. In general, a linear regression spline is obtained using
$$x_{1}= x \quad x_{2} = (x-c_{1})_+ \quad\dots\quad x_{k} = (x-c_{k-1})_+,$$
where $c_{1},\dots,c_{k-1}$ are the knots (the points at which the line can
bend). Selecting the number of knots ($k-1$) and where they should be
positioned can be difficult and somewhat arbitrary. Automatic knot selection
algorithms are available in some software, but are not yet widely used.

A smoother result is obtained using piecewise cubics rather than piecewise
lines. These are constrained so they are continuous (they join up) and they are
smooth (so there are no sudden changes of direction as we see with piecewise
linear splines). In general, a cubic regression spline is written as $$x_{1}= x
\quad x_{2}=x^2 \quad x_3=x^3 \quad x_4 = (x-c_{1})^3_+ \quad\dots\quad x_{k} =
(x-c_{k-3})^3_+.$$

An example of a cubic regression spline fitted to the fuel economy data is
shown below with a single knot at $c_{1}=25$.

![Cubic regression spline fitted to the fuel economy data.](nlcarbon2)

\@ref(fig-5-nlpulp3)

fit3 \<- lm(Carbon   City + I(City^2^) + I(City^3^) + I(Cityp^3^), data=fuel)
fcast3 \<- forecast(fit3,newdata=data.frame(City=x,Cityp=z))
plot(jitter(Carbon)   jitter(City), data=fuel) lines(x,
fcast3[[“mean”]],col=“red”)

This usually gives a better fit to the data, although forecasting values of
Carbon when City is outside the range of the historical data becomes very
unreliable.

##Correlation, causation and forecasting {#sec-5-8-MultiCol}


### Correlation is not causation {-}

It is important not to confuse correlation with causation, or causation with
forecasting. A variable $x$ may be useful for predicting a variable $y$, but
that does not mean $x$ is causing $y$. It is possible that $x$ *is* causing
$y$, but it may be that the relationship between them is more complicated than
simple causality.

For example, it is possible to model the number of drownings at a beach resort
each month with the number of ice-creams sold in the same period. The model can
give reasonable forecasts, not because ice-creams cause drownings, but because
people eat more ice-creams on hot days when they are also more likely to go
swimming. So the two variables (ice-cream sales and drownings) are correlated,
but one is not causing the other. It is important to understand that
**correlations are useful for forecasting, even when there is no causal
relationship between the two variables**.

However, often a better model is possible if a causal mechanism can be
determined. In this example, both ice-cream sales and drownings will be
affected by the temperature and by the numbers of people visiting the beach
resort. Again, high temperatures do not actually *cause* people to drown, but
they are more directly related to why people are swimming. So a better model
for drownings will probably include temperatures and visitor numbers and
exclude ice-cream sales.

### Confounded predictors {-}

A related issue involves confounding variables. Suppose we are forecasting
monthly sales of a company for 2012, using data from 2000--2011. In January 2008
a new competitor came into the market and started taking some market share. At
the same time, the economy began to decline. In your forecasting model, you
include both competitor activity (measured using advertising time on a local
television station) and the health of the economy (measured using GDP). It will
not be possible to separate the effects of these two predictors because they
are correlated. We say two variables are **confounded** when their effects on
the forecast variable cannot be separated. Any pair of correlated predictors
will have some level of confounding, but we would not normally describe them as
confounded unless there was a relatively high level of correlation between
them.

Confounding is not really a problem for forecasting, as we can still compute
forecasts without needing to separate out the effects of the predictors.
However, it becomes a problem with scenario forecasting as the scenarios should
take account of the relationships between predictors. It is also a problem if
some historical analysis of the contributions of various predictors is
required.

### Multicollinearity and forecasting {-}

A closely related issue is **multicollinearity** which occurs when similar
information is provided by two or more of the predictor variables in a multiple
regression. It can occur in a number of ways.

Two predictors are highly correlated with each other (that is, they have a
correlation coefficient close to +1 or -1). In this case, knowing the value of
one of the variables tells you a lot about the value of the other variable.
Hence, they are providing similar information.

A linear combination of predictors is highly correlated with another linear
combination of predictors. In this case, knowing the value of the first group
of predictors tells you a lot about the value of the second group of
predictors. Hence, they are providing similar information.

The dummy variable trap is a special case of multicollinearity. Suppose you
have quarterly data and use four dummy variables, $D_1,D_2,D_3$ and $D_4$. Then
$D_4=1-D_1-D_2-D_3$, so there is perfect correlation between $D_4$ and
$D_1+D_2+D_3$.

When multicollinearity occurs in a multiple regression model, there are several
consequences that you need to be aware of.

If there is perfect correlation (i.e., a correlation of +1 or -1, such as in
the dummy variable trap), it is not possible to estimate the regression model.

If there is high correlation (close to but not equal to +1 or -1), then the
estimation of the regression coefficients is computationally difficult. In
fact, some software (notably Microsoft Excel) may give highly inaccurate
estimates of the coefficients. Most reputable statistical software will use
algorithms to limit the effect of multicollinearity on the coefficient
estimates, but you do need to be careful. The major software packages such as
R, SPSS, SAS and Stata all use estimation algorithms to avoid the problem as
much as possible.

The uncertainty associated with individual regression coefficients will be
large. This is because they are difficult to estimate. Consequently,
statistical tests (e.g., t-tests) on regression coefficients are unreliable.
(In forecasting we are rarely interested in such tests.) Also, it will not be
possible to make accurate statements about the contribution of each separate
predictor to the forecast.

Forecasts will be unreliable if the values of the future predictors are outside
the range of the historical values of the predictors. For example, suppose you
have fitted a regression model with predictors $X$ and $Z$ which are highly
correlated with each other, and suppose that the values of $X$ in the fitting
data ranged between 0 and 100. Then forecasts based on $X>100$ or $X<0$ will be
unreliable. It is always a little dangerous when future values of the
predictors lie much outside the historical range, but it is especially
problematic when multicollinearity is present.

Note that if you are using good statistical software, if you are not interested
in the specific contributions of each predictor, and if the future values of
your predictor variables are within their historical ranges, there is nothing
to worry about --- multicollinearity is not a problem.

The data below (data set `fancy`) concern the monthly sales figures of a shop
which opened in January 1987 and sells gifts, souvenirs, and novelties. The
shop is situated on the wharf at a beach resort town in Queensland, Australia.
The sales volume varies with the seasonal population of tourists. There is a
large influx of visitors to the town at Christmas and for the local surfing
festival, held every March since
1988. Over time, the shop has expanded its premises, range of products, and
      staff.

=0.15cm

<span>lrrrrrrr</span> & **1987 & **1988 & **1989 & **1990 & **1991 & **1992 &
**1993\ **Jan & 1664.81 & 2499.81 & 4717.02 & 5921.10 & 4826.64 & 7615.03 &
10243.24\ **Feb & 2397.53 & 5198.24 & 5702.63 & 5814.58 & 6470.23 & 9849.69 &
11266.88\ **Mar & 2840.71 & 7225.14 & 9957.58 & 12421.25 & 9638.77 & 14558.40 &
21826.84\ **Apr & 3547.29 & 4806.03 & 5304.78 & 6369.77 & 8821.17 & 11587.33 &
17357.33\ **May & 3752.96 & 5900.88 & 6492.43 & 7609.12 & 8722.37 & 9332.56 &
15997.79\ **Jun & 3714.74 & 4951.34 & 6630.80 & 7224.75 & 10209.48 & 13082.09 &
18601.53\ **Jul & 4349.61 & 6179.12 & 7349.62 & 8121.22 & 11276.55 & 16732.78 &
26155.15\ **Aug & 3566.34 & 4752.15 & 8176.62 & 7979.25 & 12552.22 & 19888.61 &
28586.52\ **Sep & 5021.82 & 5496.43 & 8573.17 & 8093.06 & 11637.39 & 23933.38 &
30505.41\ **Oct & 6423.48 & 5835.10 & 9690.50 & 8476.70 & 13606.89 & 25391.35 &
30821.33\ **Nov & 7600.60 & 12600.08 & 15151.84 & 17914.66 & 21822.11 &
36024.80 & 46634.38\ **Dec & 19756.21 & 28541.72 & 34061.01 & 30114.41 &
45060.69 & 80721.71 & 104660.67\
**************************************

[(a)]

Produce a time plot of the data and describe the patterns in the graph.
Identify any unusual or unexpected fluctuations in the time series.

Explain why it is necessary to take logarithms of these data before fitting a
model.

Use R to fit a regression model to the logarithms of these sales data with a
linear trend, seasonal dummies and a “surfing festival” dummy variable.

Plot the residuals against time and against the fitted values. Do these plots
reveal any problems with the model?

Do boxplots of the residuals for each month. Does this reveal any problems with
the model?

What do the values of the coefficients tell you about each variable?

What does the Durbin-Watson statistic tell you about your model?

Regardless of your answers to the above questions, use your regression model to
predict the monthly sales for 1994, 1995, and 1996. Produce prediction
intervals for each of your forecasts.

Transform your predictions and intervals to obtain predictions and intervals
for the raw data.

How could you improve these predictions by modifying the model?

The data below (data set `texasgas`) shows the demand for natural gas and the
price of natural gas for 20 towns in Texas in 1969.

<span>lcc</span> **<span>City</span> & **<span>Average price</span> $P$ &
**<span>Consumption per customer</span> $C$\ & **<span>(cents per thousand
cubic feet)</span> & **<span>(thousand cubic feet)</span>\ Amarillo & 30 & 134\
Borger & 31 & 112\ Dalhart & 37 & 136\ Shamrock & 42 & 109\ Royalty & 43 & 105\
Texarkana & 45 & 87\ Corpus Christi & 50 & 56\ Palestine & 54 & 43\ Marshall &
54 & 77\ Iowa Park & 57 & 35\ Palo Pinto & 58 & 65\ Millsap & 58 & 56\ Memphis
& 60 & 58\ Granger & 73 & 55\ Llano & 88 & 49\ Brownsville & 89 & 39\ Mercedes
& 92 & 36\ Karnes City & 97 & 46\ Mathis & 100 & 40\ La Pryor & 102 & 42\
**********

[(a)]=0.16cm

Do a scatterplot of consumption against price. The data are clearly not linear.
Three possible nonlinear models for the data are given below

$$\begin{aligned} C_i &= \exp(a + bP_i+e_i) \\ C_i &= \left\{\begin{array}{ll}
a_1 + b_1P_i + e_i & \mbox{when $P_i \le 60$} \\ a_2 + b_2P_i + e_i &
\mbox{when $P_i > 60$;}
 \end{array}\right.\\
C_i &= a + b_{1}P + b_{2}P^{2}.\end{aligned}$$

The second model divides the data into two sections, depending on whether the
price is above or below 60 cents per 1,000 cubic feet.

Can you explain why the slope of the fitted line should change with $P$?

Fit the three models and find the coefficients, and residual variance in each
case.

For the second model, the parameters $a_1$, $a_2$, $b_1$, $b_2$ can be
estimated by simply fitting a regression with four regressors but no constant:
(i) a dummy taking value 1 when $P\le60$ and 0 otherwise; (ii) $\text{P1} = P$
when $P\le60$ and 0 otherwise; (iii) a dummy taking value 0 when $P\le60$ and 1
otherwise; (iv) $\text{P2}=P$ when $P>60$ and 0 otherwise.

For each model, find the value of $R^2$ and AIC, and produce a residual plot.
Comment on the adequacy of the three models.

For prices 40, 60, 80, 100, and 120 cents per 1,000 cubic feet, compute the
forecasted per capita demand using the best model of the three above.

Compute 95% prediction intervals. Make a graph of these prediction intervals
and discuss their interpretation.

What is the correlation between $P$ and $P^{2}$? Does this suggest any general
problem to be considered in dealing with polynomial regressions---especially of
higher orders?

