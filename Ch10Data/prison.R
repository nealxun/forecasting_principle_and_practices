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

dfa$sex[dfa$sex =="1"] <- "Male"
dfa$sex[dfa$sex =="2"] <- "Female"

dfa$indigenous[dfa$indigenous =="1"] <- "ATSI"
dfa$indigenous[dfa$indigenous =="2"] <- "Other"

dfa$legal[dfa$legal =="2"] <- "Sentenced"
dfa$legal[dfa$legal =="1"] <- "Remamded"



#total
ggplot(data = dfa, aes(x = quarter, y = count)) + stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners")

#group by state
ggplot(data = dfa, aes(x = quarter, y = count, group = state, colour = state))  +
  stat_summary(fun.y = sum, geom = "line")+ 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1500, 2500, 3500, 4500, 5500, 6500, 7500, 8500, 9500, 10500, 11500, 12500, 13500, 14500))


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

#group by sex
ggplot(data = dfa, aes(x = quarter, y = count, group = sex, colour = sex))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") + 
  ggtitle("Australian adult prison population by sex") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))


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

#group by legal, sex and state
ggplot(data = dfa, aes(x = quarter, y = count, group = interaction(legal, sex), colour = interaction(legal, sex)))  +
  stat_summary(fun.y = sum, geom = "line") + 
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") + 
  ggtitle("Australian adult prison population by indigenous status, legal status and state") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisoners") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 
                                9500, 10000, 10500, 11000, 11500, 12000)) +
    facet_grid(.~state)




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
                              9500, 10000, 10500, 11000, 11500, 12000)) 




################

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

dfa$count <- as.numeric(dfa$count)

dfa <- aggregate(count ~ state + sex + legal + date, data = dfa, FUN = sum)

dfa_w <- reshape(dfa, idvar = c("state", "sex", "legal"), timevar = "date", direction = "wide")

dfa_w$pathString <- paste(dfa_w$state,#length=1
                          dfa_w$sex, #length=1
                          dfa_w$legal, #length=1
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

plot(bts[,1:8])


# 8 states, 2 sex, 2 gender
state <- rep(c("NSW", "VIC", "QLD", "SA", "WA", "NT", "ACT", "TAS"), 32/8)
leg <- rep(rep(c("s","r"),each=8),2)
sex <- rep(c("M","F"),each=32/2)

state_leg <- as.character(interaction(state,leg, sep=""))
state_sex <- as.character(interaction(state,sex,sep=""))
sex_leg <- as.character(interaction(sex,leg, sep=""))

#state_leg_sex <- as.character(interaction(state,leg,sex,sep=""))


gc <-rbind(state,leg,sex,state_leg, state_sex, sex_leg)

y <- gts(bts,groups=gc)

ncol(allts(y))

tmp = forecast(y, h = 8, method = "comb", weights = "wls", fmethod = "ets")

plot(tmp)

