setwd("C:/Users/tomas/Dropbox/Forecasting Prison Numbers/Data")
setwd("C:/Users/steelto/Dropbox/Forecasting Prison Numbers/Data")
#setwd("C:/Users/steelto/Documents")

##data visualisation##

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

dfa <- read.csv("prison.csv", strip.white = TRUE)

dfa$state <- as.character(dfa$state)
dfa$sex <- as.character(dfa$sex)

dfa$indigenous[dfa$indigenous =="3"] <- "2"
dfa$indigenous <- as.character(dfa$indigenous)

dfa$legal[dfa$legal =="2"] <- "1"
dfa$legal <- as.character(dfa$legal)

dfa$legal[dfa$legal =="3"] <- "2"
dfa$legal <- as.character(dfa$legal)

dfa$legal[dfa$legal =="4"] <- "2"
dfa$legal <- as.character(dfa$legal)

#pop <- read.csv("aus_residents.csv", strip.white = TRUE)
#pop$t <- as.Date(pop$date, format = "%Y/%m/%d")

str(dfa)

dfa$t <- as.Date(dfa$date, format = "%Y/%m/%d")
str(dfa)
dfa$count <- as.numeric(dfa$count)
str(dfa)

dfa$quarter <- as.Date(cut(dfa$t, breaks = "quarter"))
dfa$year <- as.Date(cut(dfa$t, breaks="year"))


##getting the descriptions clearer in the attributes
dfa$state[dfa$state =="1"] <- "NSW"
dfa$state[dfa$state =="2"] <- "VIC"
dfa$state[dfa$state =="3"] <- "QLD"
dfa$state[dfa$state =="4"] <- "SA"
dfa$state[dfa$state =="5"] <- "WA"
dfa$state[dfa$state =="6"] <- "TAS"
dfa$state[dfa$state =="7"] <- "NT"
dfa$state[dfa$state =="8"] <- "ACT"

dfa$sex[dfa$sex =="1"] <- "M"
dfa$sex[dfa$sex =="2"] <- "F"

dfa$indigenous[dfa$indigenous =="1"] <- "ATSI"
dfa$indigenous[dfa$indigenous =="2"] <- "Other"

dfa$legal[dfa$legal =="2"] <- "Sen"
dfa$legal[dfa$legal =="1"] <- "Rem"



#total
ggplot(data = dfa, aes(x = quarter, y = count)) + stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners")

#group by legal status
ggplot(data = dfa, aes(x = quarter, y = count, group = legal, colour = legal))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by legal status") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))

#group by indigenous status
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by indigenous status") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))

#group by sex
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by sex") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))

#group by legal and indigenous
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~legal)

#group by legal and sex
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~legal)

#group by Indigenous and sex
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~indigenous)

#group by indigenous, legal and state
ggplot(data = dfa, aes(x = quarter, y = count, group = interaction(indigenous, sex), colour = interaction(indigenous, sex)))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status, legal status and state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~legal)



#group by indigenous, legal and state
ggplot(data = dfa, aes(x = quarter, y = count, group = interaction(indigenous, sex), colour = interaction(indigenous, sex)))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status, legal status and state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~legal)


#group by state
ggplot(data = dfa, aes(x = quarter, y = count, group = state, colour = state))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1500, 2500, 3500, 4500, 5500, 6500, 7500, 8500, 9500, 10500, 11500, 12500, 13500, 14500))

#group by legal and state
ggplot(data = dfa, aes(x = quarter, y = count, group = legal, colour = legal))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by legal status and state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                                9500, 10000, 10500, 11000, 11500, 12000)) +
  facet_grid(.~state)


#group by indigenous and state
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status and state") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                                9500, 10000, 10500, 11000, 11500, 12000)) +
  facet_grid(.~state)



#group by sex and state
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by sex and state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                                9500, 10000, 10500, 11000, 11500, 12000)) +
  facet_grid(.~state)

#group by indigenous and sex
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status and state") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~sex)

#group by indigenous status
ggplot(data = dfa, aes(x = quarter, y = count, group = indigenous, colour = indigenous))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by indigenous status") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  facet_grid(.~sex)

scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                              5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                              9500, 10000, 10500, 11000, 11500, 12000)) +



  
  
  
  #group by indigenous, legal and state
  ggplot(data = dfa, aes(x = quarter, y = count, group = interaction(indigenous, legal), colour = interaction(indigenous, legal)))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status, legal status and state") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                                9500, 10000, 10500, 11000, 11500, 12000)) +
  facet_grid(.~state)

################

dfa <- read.csv("data_a.csv", strip.white = TRUE)

dfa$indigenous[dfa$indigenous =="3"] <- "2"
dfa$legal[dfa$legal =="3"] <- "4"
dfa$count <- as.numeric(dfa$count)

dfa <- aggregate(count ~ state + sex + legal + indigenous + date, data = dfa, FUN = sum)

dfa_w <- reshape(dfa, idvar = c("state", "sex", "legal", "indigenous"), timevar = "date", direction = "wide")

dfa_w$pathString <- paste(dfa_w$state,#length=1
                          dfa_w$sex, #length=1
                          dfa_w$legal, #length=1
                          dfa_w$indigenous,#length=1
                              sep="")


#clean the dataset
library(data.table)
#rename the columns
setnames(dfa_w, old=c("count.2005/03/01","count.2005/06/01","count.2005/09/01","count.2005/12/01", "count.2006/03/01", "count.2006/06/01", "count.2006/09/01", "count.2006/12/01", "count.2007/03/01", "count.2007/06/01", "count.2007/09/01", "count.2007/12/01", "count.2008/03/01", "count.2008/06/01", "count.2008/09/01", "count.2008/12/01", "count.2009/03/01", "count.2009/06/01", "count.2009/09/01", "count.2009/12/01", "count.2010/03/01", "count.2010/06/01", "count.2010/09/01", "count.2010/12/01", "count.2011/03/01", "count.2011/06/01", "count.2011/09/01", "count.2011/12/01", "count.2012/03/01","count.2012/06/01","count.2012/09/01","count.2012/12/01", "count.2013/03/01", "count.2013/06/01", "count.2013/09/01", "count.2013/12/01", "count.2014/03/01", "count.2014/06/01", "count.2014/09/01", "count.2014/12/01", "count.2015/03/01", "count.2015/06/01", "count.2015/09/01", "count.2015/12/01", "count.2016/03/01","count.2016/06/01","count.2016/09/01","count.2016/12/01"), new=c("2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01"))

myvars <- c("pathString","2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01")

newdata <- dfa_w[myvars]
newdata<-newdata[!(newdata$pathString=="NANANANA"),]

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

y <- gts(bts, characters = c(1,1,1,1)) 

ncol(allts(y))

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

female

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


############
############ First need to create a smaller hierarchy
############
dfa <- read.csv("data_a.csv", strip.white = TRUE)

dfa$indigenous[dfa$indigenous =="3"] <- "2"
dfa$legal[dfa$legal =="3"] <- "4"
dfa$count <- as.numeric(dfa$count)

dfa <- aggregate(count ~ state + sex + legal + indigenous + date, data = dfa, FUN = sum)

dfa_w <- reshape(dfa, idvar = c("state", "sex", "legal", "indigenous"), timevar = "date", direction = "wide")

dfa_w$pathString <- paste(dfa_w$state,#length=1
                          dfa_w$sex, #length=1
                          #dfa_w$legal, #length=1
                          #dfa_w$indigenous,#length=1
                          sep="")


#clean the dataset
library(data.table)
#rename the columns
setnames(dfa_w, old=c("count.2005/03/01","count.2005/06/01","count.2005/09/01","count.2005/12/01", "count.2006/03/01", "count.2006/06/01", "count.2006/09/01", "count.2006/12/01", "count.2007/03/01", "count.2007/06/01", "count.2007/09/01", "count.2007/12/01", "count.2008/03/01", "count.2008/06/01", "count.2008/09/01", "count.2008/12/01", "count.2009/03/01", "count.2009/06/01", "count.2009/09/01", "count.2009/12/01", "count.2010/03/01", "count.2010/06/01", "count.2010/09/01", "count.2010/12/01", "count.2011/03/01", "count.2011/06/01", "count.2011/09/01", "count.2011/12/01", "count.2012/03/01","count.2012/06/01","count.2012/09/01","count.2012/12/01", "count.2013/03/01", "count.2013/06/01", "count.2013/09/01", "count.2013/12/01", "count.2014/03/01", "count.2014/06/01", "count.2014/09/01", "count.2014/12/01", "count.2015/03/01", "count.2015/06/01", "count.2015/09/01", "count.2015/12/01", "count.2016/03/01","count.2016/06/01","count.2016/09/01","count.2016/12/01"), new=c("2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01"))

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


nchar(newdata$pathString) #2

y <- gts(bts, characters = c(1,1)) 

plot(y, levels=0)
plot(y, levels=1)
plot(y,levels=2)
plot(y, levels=3)

#h <- 1
#for (i in 1:8) {
#  ally <- window(aggts(y), end = 2014.99 + i)
#  allf <- matrix(NA, nrow= h, ncol = ncol(ally))
#  for(i in 1:ncol(ally))
#    allf[,i] <- forecast(auto.arima(ally[,i]), h=h)$mean
#  allf <- ts(allf, start = nrow(ally)+1)
#}


#ally <- aggts(y)
#allf <- matrix(NA,nrow = h,ncol = ncol(ally))
#for(i in 1:ncol(ally))
#  allf[,i] <- forecast(auto.arima(ally[,i]),h = h)$mean
#allf <- ts(allf, start = nrow(ally)+1)
#y.f <- combinef(allf, groups = get_groups(y), keep ="gts", algorithms = "lu")


####
####
####
####
#fcasts <- vector(mode = "list", length = 10L)
#for (i in 1:10) { # start rolling forecast
#  # start from 1997, every time one more year included
#  win.y <- window(y, end = 1996 + i) 
#  fit <- auto.arima(win.y)
#  fcasts[[i]] <- forecast(fit, h = 1)
#}
#  
#  
  
  ################
  ################ Code to try and replicate for my gts object
  ################
  
#hsales1 <- as.data.frame(hsales)

#  h <- 5
#  train <- window(hsales,end=1989.99)
#  test <- window(hsales,start=1990)
#  n <- length(test) - h + 1
#  fit <- auto.arima(train)
#  order <- arimaorder(fit)
#  fcmat <- matrix(0, nrow=n, ncol=h)
#  for(i in 1:n)
#  {  
#    x <- window(hsales, end=1989.99 + (i-1)/12)
#    refit <- auto.arima(x)
#    fcmat[i,] <- forecast(refit, h=h)$mean
#}

 # n <- nrow(test)
  
#h <- 1
#ally <- aggts(y)
#train <- window(ally,end=2014.99)
#test <- window(ally,start=2015)
#n <- 8
#allf <- matrix(0, nrow=n, ncol=h)
#df = list()
#for(i in 1:n)
#  {  
#    x <- window(ally, end=2014.99 + (i-1)/4)
#    
#    allf <- matrix(NA,nrow = h,ncol = ncol(x))
#    for(i in 1:ncol(x))
#      allf[,i] <- forecast(auto.arima(x[,i]),h = h)$mean
#    df[[i]] <- allf[[i]]
#  }

#one step ahead rolling window forecasts
h <- 1
ally <- aggts(y)
allym8 <- window(ally, end=2017 - 9*(1/4))
allfm8 <- matrix(NA,nrow = h,ncol = ncol(allym8))
for(i in 1:ncol(allym8))
  allfm8[,i] <- forecast(auto.arima(allym8[,i]),h = h)$mean

allfm8 <- ts(allfm8, start = 2017 - 8*(1/4) ) #accuracy
#testm8 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 8*(1/4))
testm8 <- ally[40,]
am8 <- as.data.frame(accuracy(allfm8, testm8))
am8$step <- -8


h <- 1
ally <- aggts(y)
allym7 <- window(ally, end=2017 - 8*(1/4))
allfm7 <- matrix(NA,nrow = h,ncol = ncol(allym7))
for(i in 1:ncol(allym7))
  allfm7[,i] <- forecast(auto.arima(allym7[,i]),h = h)$mean

allfm7 <- ts(allfm7, start = 2017 - 7*(1/4) ) #accuracy
#testm7 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 7*(1/4))
testm7 <- ally[41,]
am7 <- as.data.frame(accuracy(allfm7, testm7))
am7$step <- -7

h <- 1
ally <- aggts(y)
allym6 <- window(ally, end=2017 - 7*(1/4))
allfm6 <- matrix(NA,nrow = h,ncol = ncol(allym6))
for(i in 1:ncol(allym6))
  allfm6[,i] <- forecast(auto.arima(allym6[,i]),h = h)$mean

allfm6 <- ts(allfm6, start = 2017 - 6*(1/4) )
#testm6 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 6*(1/4))
testm6 <- ally[42,]
am6 <- as.data.frame(accuracy(allfm6, testm6))
am6$step <- -6

h <- 1
ally <- aggts(y)
allym5 <- window(ally, end=2017 - 6*(1/4))
allfm5 <- matrix(NA,nrow = h,ncol = ncol(allym5))
for(i in 1:ncol(allym5))
  allfm5[,i] <- forecast(auto.arima(allym5[,i]),h = h)$mean

allfm5 <- ts(allfm5, start = 2017 - 5*(1/4) )
#testm5 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 5*(1/4))
testm5 <- ally[43,]
am5 <- as.data.frame(accuracy(allfm5, testm5))
am5$step <- -5


h <- 1
ally <- aggts(y)
allym4 <- window(ally, end=2017 - 5*(1/4))
allfm4 <- matrix(NA,nrow = h,ncol = ncol(allym4))
for(i in 1:ncol(allym4))
  allfm4[,i] <- forecast(auto.arima(allym4[,i]),h = h)$mean

allfm4 <- ts(allfm4, start = 2017 - 4*(1/4) )
#testm4 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 4*(1/4))
testm4 <- ally[44,]
am4 <- as.data.frame(accuracy(allfm4, testm4))
am4$step <- -4

h <- 1
ally <- aggts(y)
allym3 <- window(ally, end=2017 - 4*(1/4))
allfm3 <- matrix(NA,nrow = h,ncol = ncol(allym3))
for(i in 1:ncol(allym3))
  allfm3[,i] <- forecast(auto.arima(allym3[,i]),h = h)$mean

allfm3 <- ts(allfm3, start = nrow(allym3)+1 )
#testm3 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 3*(1/4))
testm3 <- ally[45,]
am3 <- as.data.frame(accuracy(allfm3, testm3))
am3$step <- -3

h <- 1
ally <- aggts(y)
allym2 <- window(ally, end=2017 - 3*(1/4))
allfm2 <- matrix(NA,nrow = h,ncol = ncol(allym2))
for(i in 1:ncol(allym2))
  allfm2[,i] <- forecast(auto.arima(allym2[,i]),h = h)$mean

allfm2 <- ts(allfm2, start = 2017 - 2*(1/4) )
#testm2 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 2*(1/4))
testm2 <- ally[46,]
am2 <- as.data.frame(accuracy(allfm2, testm2))
am2$step <- -2

h <- 1
ally <- aggts(y)
allym1 <- window(ally, end=2017 - 2*(1/4))
allfm1 <- matrix(NA,nrow = h,ncol = ncol(allym1))
for(i in 1:ncol(allym1))
  allfm1[,i] <- forecast(auto.arima(allym1[,i]),h = h)$mean

allfm1 <- ts(allfm1, start = 2017 - 1*(1/4) )
#testm1 <- window(ally, start= 2017 - 1*(1/4), end = 2017 - 1*(1/4))
testm1 <- ally[47,]
am1 <- as.data.frame(accuracy(allfm1, testm1))
am1$step <- -1

h <- 1
ally <- aggts(y)
allym0 <- window(ally, end=2017 - 1*(1/4))
allfm0 <- matrix(NA,nrow = h,ncol = ncol(allym0))
for(i in 1:ncol(allym0))
  allfm0[,i] <- forecast(auto.arima(allym0[,i]),h = h)$mean

allfm0 <- ts(allfm0, start = nrow(allym0)+1 )
#testm0 <- window(ally, start= 2017 - 0.5*(1/4), end = 2017 - 0*(1/4))
testm0 <- ally[48,]
am0 <- as.data.frame(accuracy(allfm0, testm0))
am0$step <- 0

Step1s <- rbind(am8,am7)
Step1s <- rbind(Step1s, am6)
Step1s <- rbind(Step1s, am5)
Step1s <- rbind(Step1s, am4)
Step1s <- rbind(Step1s, am3)
Step1s <- rbind(Step1s, am2)
Step1s <- rbind(Step1s, am1)
Step1s <- rbind(Step1s, am0)



#two step ahead rolling window forecasts

h <- 2
ally <- aggts(y)
allym88 <- window(ally, end=2017 - 9*(1/4))
allfm88 <- matrix(NA,nrow = h,ncol = ncol(allym88))
for(i in 1:ncol(allym88))
  allfm88[,i] <- forecast(auto.arima(allym88[,i]),h = h)$mean

allfm88 <- ts(allfm88, start = 2017 - 8*(1/4) )
#testm88 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 7*(1/4))
testm88 <- ally[40:41,]
am88 <- as.data.frame(accuracy(allfm88, testm88))
am88$step <- -8

h <- 2
ally <- aggts(y)
allym77 <- window(ally, end=2017 - 8*(1/4))
allfm77 <- matrix(NA,nrow = h,ncol = ncol(allym77))
for(i in 1:ncol(allym77))
  allfm77[,i] <- forecast(auto.arima(allym77[,i]),h = h)$mean
allfm77 <- ts(allfm77, start = 2017 - 7*(1/4) )
#testm77 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 6*(1/4))
testm77 <- ally[41:42,]
am77 <- as.data.frame(accuracy(allfm77, testm77))
am77$step <- -7


h <- 2
ally <- aggts(y)
allym66 <- window(ally, end=2017 - 7*(1/4))
allfm66 <- matrix(NA,nrow = h,ncol = ncol(allym66))
for(i in 1:ncol(allym66))
  allfm66[,i] <- forecast(auto.arima(allym66[,i]),h = h)$mean
allfm66 <- ts(allfm66, start = 2017 - 6*(1/4) )
#testm66 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 5*(1/4))
testm66 <- ally[42:43,]
am66 <- as.data.frame(accuracy(allfm66, testm66))
am66$step <- -6


h <- 2
ally <- aggts(y)
allym55 <- window(ally, end=2017 - 6*(1/4))
allfm55 <- matrix(NA,nrow = h,ncol = ncol(allym55))
for(i in 1:ncol(allym55))
  allfm55[,i] <- forecast(auto.arima(allym55[,i]),h = h)$mean
allfm55 <- ts(allfm55, start = 2017 - 5*(1/4) )
#testm55 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 4*(1/4))
testm55 <- ally[43:44,]
am55 <- as.data.frame(accuracy(allfm55, testm55))
am55$step <- -5


h <- 2
ally <- aggts(y)
allym44 <- window(ally, end=2017 - 5*(1/4))
allfm44 <- matrix(NA,nrow = h,ncol = ncol(allym44))
for(i in 1:ncol(allym44))
  allfm44[,i] <- forecast(auto.arima(allym55[,i]),h = h)$mean
allfm44 <- ts(allfm44, start = 2017 - 4*(1/4) )
#testm44 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 3*(1/4))
testm44 <- ally[44:45,]
am44 <- as.data.frame(accuracy(allfm44, testm44))
am44$step <- -4



h <- 2
ally <- aggts(y)
allym33 <- window(ally, end=2017 - 4*(1/4))
allfm33 <- matrix(NA,nrow = h,ncol = ncol(allym33))
for(i in 1:ncol(allym33))
  allfm33[,i] <- forecast(auto.arima(allym33[,i]),h = h)$mean
allfm33 <- ts(allfm33, start = 2017 - 3*(1/4) )
#testm33 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 2*(1/4))
testm33 <- ally[45:46,]
am33 <- as.data.frame(accuracy(allfm33, testm33))
am33$step <- -8

h <- 2
ally <- aggts(y)
allym22 <- window(ally, end=2017 - 3*(1/4))
allfm22 <- matrix(NA,nrow = h,ncol = ncol(allym22))
for(i in 1:ncol(allym22))
  allfm22[,i] <- forecast(auto.arima(allym22[,i]),h = h)$mean
allfm22 <- ts(allfm22, start = 2017 - 2*(1/4) )
#testm22 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 1*(1/4))
testm22 <- ally[46:47,]
am22 <- as.data.frame(accuracy(allfm22, testm22))
am22$step <- -2


h <- 2
ally <- aggts(y)
allym11 <- window(ally, end=2017 - 2*(1/4))
allfm11 <- matrix(NA,nrow = h,ncol = ncol(allym11))
for(i in 1:ncol(allym11))
  allfm11[,i] <- forecast(auto.arima(allym11[,i]),h = h)$mean
allfm11 <- ts(allfm11, start = 2017 - 1*(1/4) )
#testm11 <- window(ally, start= 2017 - 1*(1/4), end = 2017 - 0*(1/4))
testm11 <- ally[47:48,]
am11 <- as.data.frame(accuracy(allfm11, testm11))
am11$step <- -1


Step2s <- rbind(am88,am77)
Step2s <- rbind(Step2s, am66)
Step2s <- rbind(Step2s, am55)
Step2s <- rbind(Step2s, am44)
Step2s <- rbind(Step2s, am33)
Step2s <- rbind(Step2s, am22)
Step2s <- rbind(Step2s, am11)





#three step ahead rolling forecasts
h <- 3
ally <- aggts(y)
allym888 <- window(ally, end=2017 - 9*(1/4))
allfm888 <- matrix(NA,nrow = h,ncol = ncol(allym888))
for(i in 1:ncol(allym888))
  allfm888[,i] <- forecast(auto.arima(allym888[,i]),h = h)$mean
allfm888 <- ts(allfm888, start = 2017 - 8*(1/4) )
#testm888 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 6*(1/4))
testm888 <- ally[40:42,]
am888 <- as.data.frame(accuracy(allfm888, testm888))
am888$step <- -8


h <- 3
ally <- aggts(y)
allym777 <- window(ally, end=2017 - 8*(1/4))
allfm777 <- matrix(NA,nrow = h,ncol = ncol(allym777))
for(i in 1:ncol(allym777))
  allfm777[,i] <- forecast(auto.arima(allym777[,i]),h = h)$mean
allfm777 <- ts(allfm777, start = 2017 - 7*(1/4) )
#testm777 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 5*(1/4))
testm777 <- ally[41:43,]
am777 <- as.data.frame(accuracy(allfm777, testm777))
am777$step <- -7


h <- 3
ally <- aggts(y)
allym666 <- window(ally, end=2017 - 7*(1/4))
allfm666 <- matrix(NA,nrow = h,ncol = ncol(allym888))
for(i in 1:ncol(allym666))
  allfm666[,i] <- forecast(auto.arima(allym666[,i]),h = h)$mean
allfm666 <- ts(allfm666, start = 2017 - 6*(1/4) )
#testm666 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 4*(1/4))
testm666 <- ally[42:44,]
am666 <- as.data.frame(accuracy(allfm666, testm666))
am666$step <- -6

h <- 3
ally <- aggts(y)
allym555 <- window(ally, end=2017 - 6*(1/4))
allfm555 <- matrix(NA,nrow = h,ncol = ncol(allym555))
for(i in 1:ncol(allym555))
  allfm555[,i] <- forecast(auto.arima(allym555[,i]),h = h)$mean
allfm555 <- ts(allfm555, start = 2017 - 5*(1/4) )
#testm555 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 3*(1/4))
testm555 <- ally[43:45,]
am555 <- as.data.frame(accuracy(allfm555, testm555))
am555$step <- -5                 
                 
h <- 3
ally <- aggts(y)
allym444 <- window(ally, end=2017 - 5*(1/4))
allfm444 <- matrix(NA,nrow = h,ncol = ncol(allym444))
for(i in 1:ncol(allym444))
  allfm444[,i] <- forecast(auto.arima(allym444[,i]),h = h)$mean
allfm444 <- ts(allfm444, start = 2017 - 4*(1/4) )
#testm444 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 2*(1/4))
testm444 <- ally[44:46,]
am444 <- as.data.frame(accuracy(allfm444, testm444))
am444$step <- -4                 


h <- 3
ally <- aggts(y)
allym333 <- window(ally, end=2017 - 4*(1/4))
allfm333 <- matrix(NA,nrow = h,ncol = ncol(allym333))
for(i in 1:ncol(allym333))
  allfm333[,i] <- forecast(auto.arima(allym333[,i]),h = h)$mean
allfm333 <- ts(allfm333, start = 2017 - 3*(1/4) )
#testm333 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 1*(1/4))
testm333 <- ally[45:47,]
am333 <- as.data.frame(accuracy(allfm333, testm333))
am333$step <- -3                 


h <- 3
ally <- aggts(y)
allym222 <- window(ally, end=2017 - 3*(1/4))
allfm222 <- matrix(NA,nrow = h,ncol = ncol(allym222))
for(i in 1:ncol(allym222))
  allfm222[,i] <- forecast(auto.arima(allym222[,i]),h = h)$mean
allfm222 <- ts(allfm222, start = 2017 - 2*(1/4) )
#testm222 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 0*(1/4))
testm222 <- ally[46:48,]
am222 <- as.data.frame(accuracy(allfm222, testm222))
am222$step <- -2                 


Step3s <- rbind(am888,am777)
Step3s <- rbind(Step3s, am666)
Step3s <- rbind(Step3s, am555)
Step3s <- rbind(Step3s, am444)
Step3s <- rbind(Step3s, am333)
Step3s <- rbind(Step3s, am222)


                  
#four step ahead rolling window forecasts
h <- 4
ally <- aggts(y)
allym8888 <- window(ally, end=2017 - 9*(1/4))
allfm8888 <- matrix(NA,nrow = h,ncol = ncol(allym8888))
for(i in 1:ncol(allym8888))
  allfm8888[,i] <- forecast(auto.arima(allym8888[,i]),h = h)$mean
allfm8888 <- ts(allfm8888, start = 2017 - 8*(1/4) )
#testm8888 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 5*(1/4))
testm8888 <- ally[40:43,]
am8888 <- as.data.frame(accuracy(allfm8888, testm8888))
am8888$step <- -8  



h <- 4
ally <- aggts(y)
allym7777 <- window(ally, end=2017 - 8*(1/4))
allfm7777 <- matrix(NA,nrow = h,ncol = ncol(allym7777))
for(i in 1:ncol(allym7777))
  allfm7777[,i] <- forecast(auto.arima(allym7777[,i]),h = h)$mean
allfm7777 <- ts(allfm7777, start = 2017 - 7*(1/4) )
#testm7777 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 4*(1/4))
testm7777 <- ally[41:44,]
am7777 <- as.data.frame(accuracy(allfm7777, testm7777))
am7777$step <- -7


h <- 4
ally <- aggts(y)
allym6666 <- window(ally, end=2017 - 7*(1/4))
allfm6666 <- matrix(NA,nrow = h,ncol = ncol(allym6666))
for(i in 1:ncol(allym6666))
  allfm6666[,i] <- forecast(auto.arima(allym6666[,i]),h = h)$mean
allfm6666 <- ts(allfm6666, start = 2017 - 6*(1/4) )
#testm6666 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 3*(1/4))
testm6666 <- ally[42:45,]
am6666 <- as.data.frame(accuracy(allfm6666, testm6666))
am6666$step <- -6


h <- 4
ally <- aggts(y)
allym5555 <- window(ally, end=2017 - 6*(1/4))
allfm5555 <- matrix(NA,nrow = h,ncol = ncol(allym5555))
for(i in 1:ncol(allym5555))
  allfm5555[,i] <- forecast(auto.arima(allym5555[,i]),h = h)$mean
allfm5555 <- ts(allfm5555, start = 2017 - 5*(1/4) )
#testm5555 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 2*(1/4))
testm5555 <- ally[43:46,]
am5555 <- as.data.frame(accuracy(allfm5555, testm5555))
am5555$step <- -5


h <- 4
ally <- aggts(y)
allym4444 <- window(ally, end=2017 - 5*(1/4))
allfm4444 <- matrix(NA,nrow = h,ncol = ncol(allym4444))
for(i in 1:ncol(allym4444))
  allfm4444[,i] <- forecast(auto.arima(allym4444[,i]),h = h)$mean
allfm4444 <- ts(allfm4444, start = 2017 - 4*(1/4) )
#testm4444 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 1*(1/4))
testm4444 <- ally[44:47,]
am4444 <- as.data.frame(accuracy(allfm4444, testm4444))
am4444$step <- -4


                  
h <- 4
ally <- aggts(y)
allym3333 <- window(ally, end=2017 - 4*(1/4))
allfm3333 <- matrix(NA,nrow = h,ncol = ncol(allym3333))
for(i in 1:ncol(allym3333))
  allfm3333[,i] <- forecast(auto.arima(allym3333[,i]),h = h)$mean
allfm3333 <- ts(allfm3333, start = 2017 - 3*(1/4) )
#testm3333 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 0*(1/4))
testm3333 <- ally[45:48,]
am3333 <- as.data.frame(accuracy(allfm3333, testm3333))
am3333$step <- -3

Step4s <- rbind(am8888,am7777)
Step4s <- rbind(Step4s, am6666)
Step4s <- rbind(Step4s, am5555)
Step4s <- rbind(Step4s, am4444)
Step4s <- rbind(Step4s, am3333)

Step1s$steps <- 1
Step2s$steps <- 2
Step3s$steps <- 3
Step4s$steps <- 4

a_ets <- rbind(Step1s, Step2s)
a_ets <- rbind(a_ets, Step3s)
a_ets <- rbind(a_ets, Step4s)


ggplot(Step1s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("One step ahead rolling window ETS base forecast accuracy")
ggplot(Step2s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Two step ahead rolling window ETS base forecast accuracy")
ggplot(Step3s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Three step ahead rolling window ETS base forecast accuracy")

ets_accuracy <- ggplot(a_ets, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Rolling window ETS base forecast accuracy") + facet_grid(.~steps)

#####
##### ARIMA 
#####

#one step ahead rolling window forecasts
h <- 1
ally <- aggts(y)
allym8 <- window(ally, end=2017 - 9*(1/4))
allfm8 <- matrix(NA,nrow = h,ncol = ncol(allym8))
for(i in 1:ncol(allym8))
  allfm8[,i] <- forecast(auto.arima(allym8[,i]),h = h)$mean

allfm8 <- ts(allfm8, start = 2017 - 8*(1/4) ) #accuracy
#testm8 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 8*(1/4))
testm8 <- ally[40,]
am8 <- as.data.frame(accuracy(allfm8, testm8))
am8$step <- -8


h <- 1
ally <- aggts(y)
allym7 <- window(ally, end=2017 - 8*(1/4))
allfm7 <- matrix(NA,nrow = h,ncol = ncol(allym7))
for(i in 1:ncol(allym7))
  allfm7[,i] <- forecast(auto.arima(allym7[,i]),h = h)$mean

allfm7 <- ts(allfm7, start = 2017 - 7*(1/4) ) #accuracy
#testm7 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 7*(1/4))
testm7 <- ally[41,]
am7 <- as.data.frame(accuracy(allfm7, testm7))
am7$step <- -7

h <- 1
ally <- aggts(y)
allym6 <- window(ally, end=2017 - 7*(1/4))
allfm6 <- matrix(NA,nrow = h,ncol = ncol(allym6))
for(i in 1:ncol(allym6))
  allfm6[,i] <- forecast(auto.arima(allym6[,i]),h = h)$mean

allfm6 <- ts(allfm6, start = 2017 - 6*(1/4) )
#testm6 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 6*(1/4))
testm6 <- ally[42,]
am6 <- as.data.frame(accuracy(allfm6, testm6))
am6$step <- -6

h <- 1
ally <- aggts(y)
allym5 <- window(ally, end=2017 - 6*(1/4))
allfm5 <- matrix(NA,nrow = h,ncol = ncol(allym5))
for(i in 1:ncol(allym5))
  allfm5[,i] <- forecast(auto.arima(allym5[,i]),h = h)$mean

allfm5 <- ts(allfm5, start = 2017 - 5*(1/4) )
#testm5 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 5*(1/4))
testm5 <- ally[43,]
am5 <- as.data.frame(accuracy(allfm5, testm5))
am5$step <- -5


h <- 1
ally <- aggts(y)
allym4 <- window(ally, end=2017 - 5*(1/4))
allfm4 <- matrix(NA,nrow = h,ncol = ncol(allym4))
for(i in 1:ncol(allym4))
  allfm4[,i] <- forecast(auto.arima(allym4[,i]),h = h)$mean

allfm4 <- ts(allfm4, start = 2017 - 4*(1/4) )
#testm4 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 4*(1/4))
testm4 <- ally[44,]
am4 <- as.data.frame(accuracy(allfm4, testm4))
am4$step <- -4

h <- 1
ally <- aggts(y)
allym3 <- window(ally, end=2017 - 4*(1/4))
allfm3 <- matrix(NA,nrow = h,ncol = ncol(allym3))
for(i in 1:ncol(allym3))
  allfm3[,i] <- forecast(auto.arima(allym3[,i]),h = h)$mean

allfm3 <- ts(allfm3, start = nrow(allym3)+1 )
#testm3 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 3*(1/4))
testm3 <- ally[45,]
am3 <- as.data.frame(accuracy(allfm3, testm3))
am3$step <- -3

h <- 1
ally <- aggts(y)
allym2 <- window(ally, end=2017 - 3*(1/4))
allfm2 <- matrix(NA,nrow = h,ncol = ncol(allym2))
for(i in 1:ncol(allym2))
  allfm2[,i] <- forecast(auto.arima(allym2[,i]),h = h)$mean

allfm2 <- ts(allfm2, start = 2017 - 2*(1/4) )
#testm2 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 2*(1/4))
testm2 <- ally[46,]
am2 <- as.data.frame(accuracy(allfm2, testm2))
am2$step <- -2

h <- 1
ally <- aggts(y)
allym1 <- window(ally, end=2017 - 2*(1/4))
allfm1 <- matrix(NA,nrow = h,ncol = ncol(allym1))
for(i in 1:ncol(allym1))
  allfm1[,i] <- forecast(auto.arima(allym1[,i]),h = h)$mean

allfm1 <- ts(allfm1, start = 2017 - 1*(1/4) )
#testm1 <- window(ally, start= 2017 - 1*(1/4), end = 2017 - 1*(1/4))
testm1 <- ally[47,]
am1 <- as.data.frame(accuracy(allfm1, testm1))
am1$step <- -1

h <- 1
ally <- aggts(y)
allym0 <- window(ally, end=2017 - 1*(1/4))
allfm0 <- matrix(NA,nrow = h,ncol = ncol(allym0))
for(i in 1:ncol(allym0))
  allfm0[,i] <- forecast(auto.arima(allym0[,i]),h = h)$mean

allfm0 <- ts(allfm0, start = nrow(allym0)+1 )
#testm0 <- window(ally, start= 2017 - 0.5*(1/4), end = 2017 - 0*(1/4))
testm0 <- ally[48,]
am0 <- as.data.frame(accuracy(allfm0, testm0))
am0$step <- 0

Step1s <- rbind(am8,am7)
Step1s <- rbind(Step1s, am6)
Step1s <- rbind(Step1s, am5)
Step1s <- rbind(Step1s, am4)
Step1s <- rbind(Step1s, am3)
Step1s <- rbind(Step1s, am2)
Step1s <- rbind(Step1s, am1)
Step1s <- rbind(Step1s, am0)



#two step ahead rolling window forecasts

h <- 2
ally <- aggts(y)
allym88 <- window(ally, end=2017 - 9*(1/4))
allfm88 <- matrix(NA,nrow = h,ncol = ncol(allym88))
for(i in 1:ncol(allym88))
  allfm88[,i] <- forecast(auto.arima(allym88[,i]),h = h)$mean

allfm88 <- ts(allfm88, start = 2017 - 8*(1/4) )
#testm88 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 7*(1/4))
testm88 <- ally[40:41,]
am88 <- as.data.frame(accuracy(allfm88, testm88))
am88$step <- -8

h <- 2
ally <- aggts(y)
allym77 <- window(ally, end=2017 - 8*(1/4))
allfm77 <- matrix(NA,nrow = h,ncol = ncol(allym77))
for(i in 1:ncol(allym77))
  allfm77[,i] <- forecast(auto.arima(allym77[,i]),h = h)$mean
allfm77 <- ts(allfm77, start = 2017 - 7*(1/4) )
#testm77 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 6*(1/4))
testm77 <- ally[41:42,]
am77 <- as.data.frame(accuracy(allfm77, testm77))
am77$step <- -7


h <- 2
ally <- aggts(y)
allym66 <- window(ally, end=2017 - 7*(1/4))
allfm66 <- matrix(NA,nrow = h,ncol = ncol(allym66))
for(i in 1:ncol(allym66))
  allfm66[,i] <- forecast(auto.arima(allym66[,i]),h = h)$mean
allfm66 <- ts(allfm66, start = 2017 - 6*(1/4) )
#testm66 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 5*(1/4))
testm66 <- ally[42:43,]
am66 <- as.data.frame(accuracy(allfm66, testm66))
am66$step <- -6


h <- 2
ally <- aggts(y)
allym55 <- window(ally, end=2017 - 6*(1/4))
allfm55 <- matrix(NA,nrow = h,ncol = ncol(allym55))
for(i in 1:ncol(allym55))
  allfm55[,i] <- forecast(auto.arima(allym55[,i]),h = h)$mean
allfm55 <- ts(allfm55, start = 2017 - 5*(1/4) )
#testm55 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 4*(1/4))
testm55 <- ally[43:44,]
am55 <- as.data.frame(accuracy(allfm55, testm55))
am55$step <- -5


h <- 2
ally <- aggts(y)
allym44 <- window(ally, end=2017 - 5*(1/4))
allfm44 <- matrix(NA,nrow = h,ncol = ncol(allym44))
for(i in 1:ncol(allym44))
  allfm44[,i] <- forecast(auto.arima(allym55[,i]),h = h)$mean
allfm44 <- ts(allfm44, start = 2017 - 4*(1/4) )
#testm44 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 3*(1/4))
testm44 <- ally[44:45,]
am44 <- as.data.frame(accuracy(allfm44, testm44))
am44$step <- -4



h <- 2
ally <- aggts(y)
allym33 <- window(ally, end=2017 - 4*(1/4))
allfm33 <- matrix(NA,nrow = h,ncol = ncol(allym33))
for(i in 1:ncol(allym33))
  allfm33[,i] <- forecast(auto.arima(allym33[,i]),h = h)$mean
allfm33 <- ts(allfm33, start = 2017 - 3*(1/4) )
#testm33 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 2*(1/4))
testm33 <- ally[45:46,]
am33 <- as.data.frame(accuracy(allfm33, testm33))
am33$step <- -8

h <- 2
ally <- aggts(y)
allym22 <- window(ally, end=2017 - 3*(1/4))
allfm22 <- matrix(NA,nrow = h,ncol = ncol(allym22))
for(i in 1:ncol(allym22))
  allfm22[,i] <- forecast(auto.arima(allym22[,i]),h = h)$mean
allfm22 <- ts(allfm22, start = 2017 - 2*(1/4) )
#testm22 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 1*(1/4))
testm22 <- ally[46:47,]
am22 <- as.data.frame(accuracy(allfm22, testm22))
am22$step <- -2


h <- 2
ally <- aggts(y)
allym11 <- window(ally, end=2017 - 2*(1/4))
allfm11 <- matrix(NA,nrow = h,ncol = ncol(allym11))
for(i in 1:ncol(allym11))
  allfm11[,i] <- forecast(auto.arima(allym11[,i]),h = h)$mean
allfm11 <- ts(allfm11, start = 2017 - 1*(1/4) )
#testm11 <- window(ally, start= 2017 - 1*(1/4), end = 2017 - 0*(1/4))
testm11 <- ally[47:48,]
am11 <- as.data.frame(accuracy(allfm11, testm11))
am11$step <- -1


Step2s <- rbind(am88,am77)
Step2s <- rbind(Step2s, am66)
Step2s <- rbind(Step2s, am55)
Step2s <- rbind(Step2s, am44)
Step2s <- rbind(Step2s, am33)
Step2s <- rbind(Step2s, am22)
Step2s <- rbind(Step2s, am11)





#three step ahead rolling forecasts
h <- 3
ally <- aggts(y)
allym888 <- window(ally, end=2017 - 9*(1/4))
allfm888 <- matrix(NA,nrow = h,ncol = ncol(allym888))
for(i in 1:ncol(allym888))
  allfm888[,i] <- forecast(auto.arima(allym888[,i]),h = h)$mean
allfm888 <- ts(allfm888, start = 2017 - 8*(1/4) )
#testm888 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 6*(1/4))
testm888 <- ally[40:42,]
am888 <- as.data.frame(accuracy(allfm888, testm888))
am888$step <- -8


h <- 3
ally <- aggts(y)
allym777 <- window(ally, end=2017 - 8*(1/4))
allfm777 <- matrix(NA,nrow = h,ncol = ncol(allym777))
for(i in 1:ncol(allym777))
  allfm777[,i] <- forecast(auto.arima(allym777[,i]),h = h)$mean
allfm777 <- ts(allfm777, start = 2017 - 7*(1/4) )
#testm777 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 5*(1/4))
testm777 <- ally[41:43,]
am777 <- as.data.frame(accuracy(allfm777, testm777))
am777$step <- -7


h <- 3
ally <- aggts(y)
allym666 <- window(ally, end=2017 - 7*(1/4))
allfm666 <- matrix(NA,nrow = h,ncol = ncol(allym888))
for(i in 1:ncol(allym666))
  allfm666[,i] <- forecast(auto.arima(allym666[,i]),h = h)$mean
allfm666 <- ts(allfm666, start = 2017 - 6*(1/4) )
#testm666 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 4*(1/4))
testm666 <- ally[42:44,]
am666 <- as.data.frame(accuracy(allfm666, testm666))
am666$step <- -6

h <- 3
ally <- aggts(y)
allym555 <- window(ally, end=2017 - 6*(1/4))
allfm555 <- matrix(NA,nrow = h,ncol = ncol(allym555))
for(i in 1:ncol(allym555))
  allfm555[,i] <- forecast(auto.arima(allym555[,i]),h = h)$mean
allfm555 <- ts(allfm555, start = 2017 - 5*(1/4) )
#testm555 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 3*(1/4))
testm555 <- ally[43:45,]
am555 <- as.data.frame(accuracy(allfm555, testm555))
am555$step <- -5                 

h <- 3
ally <- aggts(y)
allym444 <- window(ally, end=2017 - 5*(1/4))
allfm444 <- matrix(NA,nrow = h,ncol = ncol(allym444))
for(i in 1:ncol(allym444))
  allfm444[,i] <- forecast(auto.arima(allym444[,i]),h = h)$mean
allfm444 <- ts(allfm444, start = 2017 - 4*(1/4) )
#testm444 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 2*(1/4))
testm444 <- ally[44:46,]
am444 <- as.data.frame(accuracy(allfm444, testm444))
am444$step <- -4                 


h <- 3
ally <- aggts(y)
allym333 <- window(ally, end=2017 - 4*(1/4))
allfm333 <- matrix(NA,nrow = h,ncol = ncol(allym333))
for(i in 1:ncol(allym333))
  allfm333[,i] <- forecast(auto.arima(allym333[,i]),h = h)$mean
allfm333 <- ts(allfm333, start = 2017 - 3*(1/4) )
#testm333 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 1*(1/4))
testm333 <- ally[45:47,]
am333 <- as.data.frame(accuracy(allfm333, testm333))
am333$step <- -3                 


h <- 3
ally <- aggts(y)
allym222 <- window(ally, end=2017 - 3*(1/4))
allfm222 <- matrix(NA,nrow = h,ncol = ncol(allym222))
for(i in 1:ncol(allym222))
  allfm222[,i] <- forecast(auto.arima(allym222[,i]),h = h)$mean
allfm222 <- ts(allfm222, start = 2017 - 2*(1/4) )
#testm222 <- window(ally, start= 2017 - 2*(1/4), end = 2017 - 0*(1/4))
testm222 <- ally[46:48,]
am222 <- as.data.frame(accuracy(allfm222, testm222))
am222$step <- -2                 


Step3s <- rbind(am888,am777)
Step3s <- rbind(Step3s, am666)
Step3s <- rbind(Step3s, am555)
Step3s <- rbind(Step3s, am444)
Step3s <- rbind(Step3s, am333)
Step3s <- rbind(Step3s, am222)



#four step ahead rolling window forecasts
h <- 4
ally <- aggts(y)
allym8888 <- window(ally, end=2017 - 9*(1/4))
allfm8888 <- matrix(NA,nrow = h,ncol = ncol(allym8888))
for(i in 1:ncol(allym8888))
  allfm8888[,i] <- forecast(auto.arima(allym8888[,i]),h = h)$mean
allfm8888 <- ts(allfm8888, start = 2017 - 8*(1/4) )
#testm8888 <- window(ally, start= 2017 - 8*(1/4), end = 2017 - 5*(1/4))
testm8888 <- ally[40:43,]
am8888 <- as.data.frame(accuracy(allfm8888, testm8888))
am8888$step <- -8  



h <- 4
ally <- aggts(y)
allym7777 <- window(ally, end=2017 - 8*(1/4))
allfm7777 <- matrix(NA,nrow = h,ncol = ncol(allym7777))
for(i in 1:ncol(allym7777))
  allfm7777[,i] <- forecast(auto.arima(allym7777[,i]),h = h)$mean
allfm7777 <- ts(allfm7777, start = 2017 - 7*(1/4) )
#testm7777 <- window(ally, start= 2017 - 7*(1/4), end = 2017 - 4*(1/4))
testm7777 <- ally[41:44,]
am7777 <- as.data.frame(accuracy(allfm7777, testm7777))
am7777$step <- -7


h <- 4
ally <- aggts(y)
allym6666 <- window(ally, end=2017 - 7*(1/4))
allfm6666 <- matrix(NA,nrow = h,ncol = ncol(allym6666))
for(i in 1:ncol(allym6666))
  allfm6666[,i] <- forecast(auto.arima(allym6666[,i]),h = h)$mean
allfm6666 <- ts(allfm6666, start = 2017 - 6*(1/4) )
#testm6666 <- window(ally, start= 2017 - 6*(1/4), end = 2017 - 3*(1/4))
testm6666 <- ally[42:45,]
am6666 <- as.data.frame(accuracy(allfm6666, testm6666))
am6666$step <- -6


h <- 4
ally <- aggts(y)
allym5555 <- window(ally, end=2017 - 6*(1/4))
allfm5555 <- matrix(NA,nrow = h,ncol = ncol(allym5555))
for(i in 1:ncol(allym5555))
  allfm5555[,i] <- forecast(auto.arima(allym5555[,i]),h = h)$mean
allfm5555 <- ts(allfm5555, start = 2017 - 5*(1/4) )
#testm5555 <- window(ally, start= 2017 - 5*(1/4), end = 2017 - 2*(1/4))
testm5555 <- ally[43:46,]
am5555 <- as.data.frame(accuracy(allfm5555, testm5555))
am5555$step <- -5


h <- 4
ally <- aggts(y)
allym4444 <- window(ally, end=2017 - 5*(1/4))
allfm4444 <- matrix(NA,nrow = h,ncol = ncol(allym4444))
for(i in 1:ncol(allym4444))
  allfm4444[,i] <- forecast(auto.arima(allym4444[,i]),h = h)$mean
allfm4444 <- ts(allfm4444, start = 2017 - 4*(1/4) )
#testm4444 <- window(ally, start= 2017 - 4*(1/4), end = 2017 - 1*(1/4))
testm4444 <- ally[44:47,]
am4444 <- as.data.frame(accuracy(allfm4444, testm4444))
am4444$step <- -4



h <- 4
ally <- aggts(y)
allym3333 <- window(ally, end=2017 - 4*(1/4))
allfm3333 <- matrix(NA,nrow = h,ncol = ncol(allym3333))
for(i in 1:ncol(allym3333))
  allfm3333[,i] <- forecast(auto.arima(allym3333[,i]),h = h)$mean
allfm3333 <- ts(allfm3333, start = 2017 - 3*(1/4) )
#testm3333 <- window(ally, start= 2017 - 3*(1/4), end = 2017 - 0*(1/4))
testm3333 <- ally[45:48,]
am3333 <- as.data.frame(accuracy(allfm3333, testm3333))
am3333$step <- -3

Step4s <- rbind(am8888,am7777)
Step4s <- rbind(Step4s, am6666)
Step4s <- rbind(Step4s, am5555)
Step4s <- rbind(Step4s, am4444)
Step4s <- rbind(Step4s, am3333)

Step1s$steps <- 1
Step2s$steps <- 2
Step3s$steps <- 3
Step4s$steps <- 4

a_arima <- rbind(Step1s, Step2s)
a_arima <- rbind(a_arima, Step3s)
a_arima <- rbind(a_arima, Step4s)


ggplot(Step1s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("One step ahead rolling window arima base forecast accuracy")
ggplot(Step2s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Two step ahead rolling window arima base forecast accuracy")
ggplot(Step3s, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Three step ahead rolling window arima base forecast accuracy")

a_arima <- ggplot(a_arima, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Rolling window arima base forecast accuracy") + facet_grid(.~steps)


#####
#####
#####
#####

#One step ahead rolling window arima reconciled forecasts
h <- 1
allym8 <- window(y, end=2017 - 9*(1/4))
allfm8 <- forecast(allym8, h=h, method="comb", fmethod="arima", weights = "mint")

#testm8 <- window(y, start= 2017 - 8*(1/4), end = 2017 - 8*(1/4))

allfm8 <- ts(aggts(allfm8), start = 2017 - 8*(1/4))
testm8 <- ally[40,]
am8 <- as.data.frame(accuracy(allfm8, testm8))
am8$step <- -8


allym7 <- window(y, end=2017 - 8*(1/4))
allfm7 <- forecast(allym7, h=h, method="comb", fmethod="arima", weights = "mint")
allfm7 <- ts(aggts(allfm7), start = 2017 - 7*(1/4))
testm7 <- ally[41,]
am7 <- as.data.frame(accuracy(allfm7, testm7))
am7$step <- -7

allym6 <- window(y, end=2017 - 7*(1/4))
allfm6 <- forecast(allym6, h=h, method="comb", fmethod="arima", weights = "mint")
allfm6 <- ts(aggts(allfm6), start = 2017 - 6*(1/4))
testm6 <- ally[42,]
am6 <- as.data.frame(accuracy(allfm6, testm6))
am6$step <- -6

allym5 <- window(y, end=2017 - 6*(1/4))
allfm5 <- forecast(allym5, h=h, method="comb", fmethod="arima", weights = "mint")
allfm5 <- ts(aggts(allfm5), start = 2017 - 5*(1/4))
testm5 <- ally[43,]
am5 <- as.data.frame(accuracy(allfm5, testm5))
am5$step <- -5

allym4 <- window(y, end=2017 - 5*(1/4))
allfm4 <- forecast(allym4, h=h, method="comb", fmethod="arima", weights = "mint")
allfm4 <- ts(aggts(allfm4), start = 2017 - 4*(1/4))
testm4 <- ally[44,]
am4 <- as.data.frame(accuracy(allfm4, testm4))
am4$step <- -4

allym3 <- window(y, end=2017 - 4*(1/4))
allfm3 <- forecast(allym3, h=h, method="comb", fmethod="arima", weights = "mint")
allfm3 <- ts(aggts(allfm3), start = 2017 - 3*(1/4))
testm3 <- ally[45,]
am3 <- as.data.frame(accuracy(allfm3, testm3))
am3$step <- -3

allym2 <- window(y, end=2017 - 3*(1/4))
allfm2 <- forecast(allym2, h=h, method="comb", fmethod="arima", weights = "mint")
allfm2 <- ts(aggts(allfm2), start = 2017 - 2*(1/4))
testm2 <- ally[46,]
am2 <- as.data.frame(accuracy(allfm2, testm2))
am2$step <- -2

allym1 <- window(y, end=2017 - 2*(1/4))
allfm1 <- forecast(allym1, h=h, method="comb", fmethod="arima", weights = "mint")
allfm1 <- ts(aggts(allfm1), start = 2017 - 1*(1/4))
testm1 <- ally[47,]
am1 <- as.data.frame(accuracy(allfm1, testm1))
am1$step <- -1

allym0 <- window(y, end=2017 - 1*(1/4))
allfm0 <- forecast(allym0, h=h, method="comb", fmethod="arima", weights = "mint")
allfm0 <- ts(aggts(allfm0), start = 2017 - 0*(1/4))
testm0 <- ally[48,]
am0 <- as.data.frame(accuracy(allfm0, testm0))
am0$step <- 0

Step1sr <- rbind(am8,am7)
Step1sr <- rbind(Step1sr, am6)
Step1sr <- rbind(Step1sr, am5)
Step1sr <- rbind(Step1sr, am4)
Step1sr <- rbind(Step1sr, am3)
Step1sr <- rbind(Step1sr, am2)
Step1sr <- rbind(Step1sr, am1)
Step1sr <- rbind(Step1sr, am0)

#Two steps ahead rolling window arima reconciled forecasts
h <- 2
allym88 <- window(y, end=2017 - 9*(1/4))
allfm88 <- forecast(allym88, h=h, method="comb", fmethod="arima", weights = "mint")
allfm88 <- ts(aggts(allfm88), start = 2017 - 8*(1/4))
testm88 <- ally[40:41,]
am88 <- as.data.frame(accuracy(allfm88, testm88))
am88$step <- -8


allym77 <- window(y, end=2017 - 8*(1/4))
allfm77 <- forecast(allym77, h=h, method="comb", fmethod="arima", weights = "mint")
allfm77 <- ts(aggts(allfm77), start = 2017 - 7*(1/4))
testm77 <- ally[41:42,]
am77 <- as.data.frame(accuracy(allfm77, testm77))
am77$step <- -7

allym66 <- window(y, end=2017 - 7*(1/4))
allfm66 <- forecast(allym66, h=h, method="comb", fmethod="arima", weights = "mint")
allfm66 <- ts(aggts(allfm66), start = 2017 - 6*(1/4))
testm66 <- ally[42:43,]
am66 <- as.data.frame(accuracy(allfm66, testm66))
am66$step <- -6

allym55 <- window(y, end=2017 - 6*(1/4))
allfm55 <- forecast(allym55, h=h, method="comb", fmethod="arima", weights = "mint")
allfm55 <- ts(aggts(allfm55), start = 2017 - 5*(1/4))
testm55 <- ally[43:44,]
am55 <- as.data.frame(accuracy(allfm55, testm55))
am55$step <- -5

allym44 <- window(y, end=2017 - 5*(1/4))
allfm44 <- forecast(allym44, h=h, method="comb", fmethod="arima", weights = "mint")
allfm44 <- ts(aggts(allfm44), start = 2017 - 4*(1/4))
testm44 <- ally[44:45,]
am44 <- as.data.frame(accuracy(allfm44, testm44))
am44$step <- -4

allym33 <- window(y, end=2017 - 4*(1/4))
allfm33 <- forecast(allym33, h=h, method="comb", fmethod="arima", weights = "mint")
allfm33 <- ts(aggts(allfm33), start = 2017 - 3*(1/4))
testm33 <- ally[45:46,]
am33 <- as.data.frame(accuracy(allfm33, testm33))
am33$step <- -3

allym22 <- window(y, end=2017 - 3*(1/4))
allfm22 <- forecast(allym22, h=h, method="comb", fmethod="arima", weights = "mint")
allfm22 <- ts(aggts(allfm22), start = 2017 - 2*(1/4))
testm22 <- ally[46:47,]
am22 <- as.data.frame(accuracy(allfm22, testm22))
am22$step <- -2

allym11 <- window(y, end=2017 - 2*(1/4))
allfm11 <- forecast(allym11, h=h, method="comb", fmethod="arima", weights = "mint")
allfm11 <- ts(aggts(allfm11), start = 2017 - 1*(1/4))
testm11 <- ally[47:48,]
am11 <- as.data.frame(accuracy(allfm11, testm11))
am11$step <- -1

Step2sr <- rbind(am88,am77)
Step2sr <- rbind(Step2sr, am66)
Step2sr <- rbind(Step2sr, am55)
Step2sr <- rbind(Step2sr, am44)
Step2sr <- rbind(Step2sr, am33)
Step2sr <- rbind(Step2sr, am22)

#Three steps ahead rolling window arima reconciled forecasts
h <- 3
allym888 <- window(y, end=2017 - 9*(1/4))
allfm888 <- forecast(allym888, h=h, method="comb", fmethod="arima", weights = "mint")
allfm888 <- ts(aggts(allfm888), start = 2017 - 8*(1/4))
testm888 <- ally[40:42,]
am888 <- as.data.frame(accuracy(allfm888, testm888))
am888$step <- -8


allym777 <- window(y, end=2017 - 8*(1/4))
allfm777 <- forecast(allym777, h=h, method="comb", fmethod="arima", weights = "mint")
allfm777 <- ts(aggts(allfm777), start = 2017 - 7*(1/4))
testm777 <- ally[41:43,]
am777 <- as.data.frame(accuracy(allfm777, testm777))
am777$step <- -7

allym666 <- window(y, end=2017 - 7*(1/4))
allfm666 <- forecast(allym666, h=h, method="comb", fmethod="arima", weights = "mint")
allfm666 <- ts(aggts(allfm666), start = 2017 - 6*(1/4))
testm666 <- ally[42:44,]
am666 <- as.data.frame(accuracy(allfm666, testm666))
am666$step <- -6

allym555 <- window(y, end=2017 - 6*(1/4))
allfm555 <- forecast(allym555, h=h, method="comb", fmethod="arima", weights = "mint")
allfm555 <- ts(aggts(allfm555), start = 2017 - 5*(1/4))
testm555 <- ally[43:45,]
am555 <- as.data.frame(accuracy(allfm555, testm555))
am555$step <- -5

allym444 <- window(y, end=2017 - 5*(1/4))
allfm444 <- forecast(allym444, h=h, method="comb", fmethod="arima", weights = "mint")
allfm444 <- ts(aggts(allfm444), start = 2017 - 4*(1/4))
testm44 <- ally[44:46,]
am444 <- as.data.frame(accuracy(allfm444, testm444))
am444$step <- -4

allym333 <- window(y, end=2017 - 4*(1/4))
allfm333 <- forecast(allym333, h=h, method="comb", fmethod="arima", weights = "mint")
allfm333 <- ts(aggts(allfm333), start = 2017 - 3*(1/4))
testm333 <- ally[45:47,]
am333 <- as.data.frame(accuracy(allfm333, testm333))
am333$step <- -3

allym222 <- window(y, end=2017 - 3*(1/4))
allfm222 <- forecast(allym222, h=h, method="comb", fmethod="arima", weights = "mint")
allfm222 <- ts(aggts(allfm222), start = 2017 - 2*(1/4))
testm222 <- ally[46:48,]
am222 <- as.data.frame(accuracy(allfm222, testm222))
am222$step <- -2

Step3sr <- rbind(am888,am777)
Step3sr <- rbind(Step3sr, am666)
Step3sr <- rbind(Step3sr, am555)
Step3sr <- rbind(Step3sr, am444)
Step3sr <- rbind(Step3sr, am333)
Step3sr <- rbind(Step3sr, am222)

#Four steps ahead rolling window arima reconciled forecasts
h <- 4
allym8888 <- window(y, end=2017 - 9*(1/4))
allfm8888 <- forecast(allym8888, h=h, method="comb", fmethod="arima", weights = "mint")
allfm8888 <- ts(aggts(allfm8888), start = 2017 - 8*(1/4))
testm8888 <- ally[40:43,]
am8888 <- as.data.frame(accuracy(allfm8888, testm8888))
am8888$step <- -8


allym7777 <- window(y, end=2017 - 8*(1/4))
allfm7777 <- forecast(allym7777, h=h, method="comb", fmethod="arima", weights = "mint")
allfm7777 <- ts(aggts(allfm7777), start = 2017 - 7*(1/4))
testm7777 <- ally[41:44,]
am7777 <- as.data.frame(accuracy(allfm7777, testm7777))
am7777$step <- -7

allym6666 <- window(y, end=2017 - 7*(1/4))
allfm6666 <- forecast(allym6666, h=h, method="comb", fmethod="arima", weights = "mint")
allfm6666 <- ts(aggts(allfm6666), start = 2017 - 6*(1/4))
testm6666 <- ally[42:45,]
am6666 <- as.data.frame(accuracy(allfm6666, testm6666))
am6666$step <- -6

allym5555 <- window(y, end=2017 - 6*(1/4))
allfm5555 <- forecast(allym5555, h=h, method="comb", fmethod="arima", weights = "mint")
allfm5555 <- ts(aggts(allfm5555), start = 2017 - 5*(1/4))
testm5555 <- ally[43:46,]
am5555 <- as.data.frame(accuracy(allfm5555, testm5555))
am5555$step <- -5

allym4444 <- window(y, end=2017 - 5*(1/4))
allfm4444 <- forecast(allym4444, h=h, method="comb", fmethod="arima", weights = "mint")
allfm4444 <- ts(aggts(allfm4444), start = 2017 - 4*(1/4))
testm444 <- ally[44:47,]
am4444 <- as.data.frame(accuracy(allfm4444, testm4444))
am4444$step <- -4

allym3333 <- window(y, end=2017 - 4*(1/4))
allfm3333 <- forecast(allym3333, h=h, method="comb", fmethod="arima", weights = "mint")
allfm3333 <- ts(aggts(allfm3333), start = 2017 - 3*(1/4))
testm3333 <- ally[45:48,]
am3333 <- as.data.frame(accuracy(allfm3333, testm3333))
am3333$step <- -3

Step4sr <- rbind(am8888,am7777)
Step4sr <- rbind(Step4sr, am6666)
Step4sr <- rbind(Step4sr, am5555)
Step4sr <- rbind(Step4sr, am4444)
Step4sr <- rbind(Step4sr, am3333)

Step1sr$steps <- 1
Step2sr$steps <- 2
Step3sr$steps <- 3
Step4sr$steps <- 4

ar_arima <- rbind(Step1s, Step2s)
ar_arima <- rbind(a_ets, Step3s)
ar_arima <- rbind(a_ets, Step4s)
ar_arima$fcasttype <- 'reconciled'

ggplot(Step1sr, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("One step ahead rolling window ARIMA reconciled forecast accuracy")
ggplot(Step2sr, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Two step ahead rolling window ARIMA reconciled forecast accuracy")
ggplot(Step3sr, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Three step ahead rolling window ARIMA reconciled forecast accuracy")

arimar_accuracy <- ggplot(ar_arima, aes(x=step, y=MAPE)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Rolling window ARIMA reconciled forecast accuracy") + facet_grid(.~steps)
arimar_accuracy

a_arima$fcasttype <- 'base'
arima_accuracy1 <- rbind(ar_arima, a_arima)

ggplot(arima_accuracy1, aes(x=step, y=MAPE, group=fcasttype, colour=fcasttype)) + geom_point() + geom_line(linetype="dashed") + ggtitle("Rolling window ARIMA reconciled and base forecast accuracy") + facet_grid(.~steps)

