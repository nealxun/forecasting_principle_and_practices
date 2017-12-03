# Use the last 280 obs of goog
# The reason is that anymore in the training set goog2
# we get a sign spike in the ACF of diff(goog1) at lag 3 which
# I think it is too confusing to explain so early on - or maybe
# it is a good thing?? What do you think?

# Run this to see
# goog1 <- ts(subset(goog,start=(length(goog)-350)))
# ggAcf(diff(goog1))

# Note we get a sign spike when we look at the ACF of
# goog1 in Chapter 8 -- see further below lines 120-122 -- we
# can make a point there when reading ACFs and PACFs

# Should we add goog1 in the fpp2 package as a
# shorter version of goog???
goog1 <- ts(subset(goog,start=(length(goog)-280)))
goog2 <- subset(goog1, end = 240)

#RJH Maybe use first 200 days of the series and I'll add goog200 to the package.

# Chapter 2

smallfonts <- theme(text = element_text(size = 9),
                    axis.text = element_text(size=8))
p1 <- autoplot(hsales) + smallfonts +
  xlab("Year") + ylab("millions") +
  ggtitle("Sales of new one-family houses, USA")
p2 <- autoplot(ustreas) + smallfonts +
  xlab("Day") + ylab("Number") +
  ggtitle("US treasury bill contracts")
p3 <- autoplot(qauselec) + smallfonts +
  xlab("Year") + ylab("billion kWh") +
  ggtitle("Australian quarterly electricity production")
p4 <- autoplot(diff(goog1)) + smallfonts +
  xlab("Day") + ylab("Change in prices") +
  ggtitle("Google Inc closing stock price")
gridExtra::grid.arrange(p1,p2,p3,p4,ncol=2)

# Chapter 3

autoplot(goog1)

autoplot(goog2) +
  forecast::autolayer(meanf(goog2, h=40), PI=FALSE, series="Mean") +
  forecast::autolayer(rwf(goog2, h=40), PI=FALSE, series="Naïve") +
  forecast::autolayer(rwf(goog2, drift=TRUE, h=40), PI=FALSE, series="Drift") +
  ggtitle("Dow Jones Index (daily ending 15 Jul 94)") +
  xlab("Day") + ylab("") +
  guides(colour=guide_legend(title="Forecast"))


goog2 <- window(goog1, end=240)
autoplot(goog2) + xlab("Day") + ylab("") +
  ggtitle("Dow Jones Index (daily ending 15 Jul 94)")

res <- residuals(naive(goog2))
autoplot(res) + xlab("Day") + ylab("") +
  ggtitle("Residuals from naïve method")

gghistogram(res) + ggtitle("Histogram of residuals")

ggAcf(res) + ggtitle("ACF of residuals")

Box.test(res, lag=10, fitdf=0)

Box.test(res,lag=10, fitdf=0, type="Lj")

checkresiduals(naive(goog2))

goog2 <- window(goog1, end=240)
googfc1 <- meanf(goog2, h=40)
googfc2 <- rwf(goog2, h=40)
googfc3 <- rwf(goog2, drift=TRUE, h=40)
autoplot(goog1) +
  forecast::autolayer(googfc1, PI=FALSE, series="Mean") +
  forecast::autolayer(googfc2, PI=FALSE, series="Naïve") +
  forecast::autolayer(googfc3, PI=FALSE, series="Drift") +
  xlab("Day") + ylab("") +
  ggtitle("Dow Jones Index (daily ending 15 Jul 94)") +
  guides(colour=guide_legend(title="Forecast"))


goog3 <- window(goog1, start=241)
accuracy(googfc1, goog3)
accuracy(googfc2, goog3)
accuracy(googfc3, goog3)

e <- tsCV(goog1, rwf, drift=TRUE, h=1)
sqrt(mean(e^2, na.rm=TRUE))

sqrt(mean(residuals(rwf(goog1, drift=TRUE))^2, na.rm=TRUE))

goog1 %>% tsCV(forecastfunction=rwf, drift=TRUE, h=1) -> e
e^2 %>% mean(na.rm=TRUE) %>% sqrt()
goog1 %>% rwf(drift=TRUE) %>% residuals() -> res
res^2 %>% mean(na.rm=TRUE) %>% sqrt()

e <- matrix(NA_real_, nrow = length(goog1), ncol = 8)
for (h in seq_len(8))
  e[, h] <- tsCV(goog1, forecastfunction = naive, h = h)

# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = T)

# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

naive(goog2)

autoplot(naive(goog2))

naive(goog2, bootstrap=TRUE)

# Chapter 8

pl <-list()
pl[[1]] <- autoplot(goog1, main = "(a)", xlab = "Day")
pl[[2]] <- autoplot(diff(goog1), main = "(b)", xlab = "Day")

p1 <- ggAcf(goog1)
p2 <- ggAcf(diff(goog1))
gridExtra::grid.arrange(p1,p2, nrow=1)

Box.test(diff(goog1), lag=10, type="Ljung-Box")

pv <- Box.test(diff(goog1), lag=10, type="Ljung-Box")$p.value
