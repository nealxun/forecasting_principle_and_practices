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


prison <- read.csv("Ch10Data/prisonLF.csv", strip.white = TRUE)

prison$state <- as.character(prison$state)

prison$indigenous[prison$indigenous =="3"] <- "2"
prison$indigenous <- as.character(prison$indigenous)

prison$legal[prison$legal =="2"] <- "1"
prison$legal <- as.character(prison$legal)

prison$legal[prison$legal =="3"] <- "2"
prison$legal <- as.character(prison$legal)

prison$legal[prison$legal =="4"] <- "2"
prison$legal <- as.character(prison$legal)

# prison$gender[prison$gender =="1"] <- "3"
# prison$gender[prison$gender =="2"] <- "1"
# prison$gender[prison$gender =="3"] <- "2"
prison$gender <- as.character(prison$gender)

#pop <- read.csv("aus_residents.csv", strip.white = TRUE)
#pop$t <- as.Date(pop$date, format = "%Y/%m/%d")

str(prison)

prison$t <- as.Date(prison$date, format = "%Y/%m/%d")
str(prison)
prison$count <- as.numeric(prison$count)
str(prison)

#prison$quarter <- as.Date(cut(prison$t, breaks = "quarter"))
#prison$year <- as.Date(cut(prison$t, breaks="year"))

##getting the descriptions clearer in the attributes
prison$state[prison$state =="1"] <- "NSW"
prison$state[prison$state =="2"] <- "VIC"
prison$state[prison$state =="3"] <- "QLD"
prison$state[prison$state =="4"] <- "SA"
prison$state[prison$state =="5"] <- "WA"
prison$state[prison$state =="6"] <- "TAS"
prison$state[prison$state =="7"] <- "NT"
prison$state[prison$state =="8"] <- "ACT"

prison$gender[prison$gender =="1"] <- "Male"
prison$gender[prison$gender =="2"] <- "Female"

prison$indigenous[prison$indigenous =="1"] <- "ATSI"
prison$indigenous[prison$indigenous =="2"] <- "Other"

prison$legal[prison$legal =="2"] <- "Sentenced"
prison$legal[prison$legal =="1"] <- "Remamded"

#write.csv(prison, file = "prisonLF1.csv",row.names = FALSE)
#
# I use this is the book
#

prisonLF <- read.csv("Ch10Data/prisonLF1.csv")

prisonLF$t <- as.Date(prisonLF$date, format = "%Y/%m/%d")
prisonLF$count <- as.numeric(prisonLF$count)
prisonLF$quarter <- as.Date(cut(prisonLF$t, breaks = "quarter"))
prisonLF$year <- as.Date(cut(prisonLF$t, breaks="year"))

library(scales)

#total
p1<-ggplot(data = prisonLF, aes(x = quarter, y = count)) + stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") +
  ggtitle("Australian prisonLF population: total") +
  theme(plot.title = element_text(size=12)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Number of prisonLFers")+
  scale_colour_discrete(guide = guide_legend(title = "Zone"))

#group by state
p2<-ggplot(data = prisonLF, aes(x = quarter, y = count, group = state, colour = state))  +
  stat_summary(fun.y = sum, geom = "line")+
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "18 months") +
  ggtitle("Grouped by state") +
  theme(plot.title = element_text(size=12)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Number of prisonLFers") +
  scale_y_continuous(breaks = c(0,500, 2500, 4500, 6500, 8500, 10500, 12500, 14500,60000))+
  scale_colour_discrete(guide = guide_legend(title = "State"))

#group by legal status
p3<-ggplot(data = prisonLF, aes(x = quarter, y = count, group = legal, colour = legal))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "18 months") +
  ggtitle("Grouped by legal status") +
  theme(plot.title = element_text(size=12)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Number of prisonLFers") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  scale_colour_discrete(guide = guide_legend(title = "Legal status"))

#group by gender
p4<-ggplot(data = prisonLF, aes(x = quarter, y = count, group = gender, colour = gender))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "18 months") +
  ggtitle("Grouped by gender") +
  theme(plot.title = element_text(size=12)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Number of prisonLFers") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  scale_colour_discrete(guide = guide_legend(title = "Gender"))

gridExtra::grid.arrange(p1, p2, p3, p4, nrow=2)

#group by legal and state
p5 <- ggplot(data = prisonLF, aes(x = quarter, y = count, group = legal, colour = legal))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%Y"), date_breaks= "23 months") +
  ggtitle("Australian adult prisonLF population by state and legal status") +
  theme(plot.title = element_text(size=12)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisonLFers") +
  scale_y_continuous(breaks = c(0,500, 2500, 4500, 6500, 8500, 10500, 12500, 14500,60000))+
  scale_colour_discrete(guide = guide_legend(title = "Legal status"))+
  facet_grid(.~state)

#group by gender and state
p6 <- ggplot(data = prisonLF, aes(x = quarter, y = count, group = gender, colour = gender))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%Y"), date_breaks= "18 months") +
  ggtitle("Australian adult prisonLF population by state and gender") +
  theme(plot.title = element_text(size=12)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisonLFers") +
  scale_y_continuous(breaks = c(0,500, 2500, 4500, 6500, 8500, 10500, 12500, 14500,60000))+
  scale_colour_discrete(guide = guide_legend(title = "Gender"))+
  facet_grid(.~state)

#group by legal and gender
p7<-ggplot(data = prisonLF, aes(x = quarter, y = count, group = gender, colour = gender))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%m/%Y"), date_breaks= "8 months") +
  ggtitle("Australian adult prisonLF by legal status and gender") +
  theme(plot.title = element_text(size=12)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Quarter") +
  ylab("Total number of prisonLFers") +
  scale_y_continuous(breaks = c(5000, 10000, 15000, 20000, 25000, 30000, 35000, 40000))+
  scale_colour_discrete(guide = guide_legend(title = "Gender"))+
  facet_grid(.~legal)

gridExtra::grid.arrange(p5, p6,p7, ncol=1)

#group by legal, gender and state
ggplot(data = prisonLF, aes(x = quarter, y = count, group = interaction(legal, gender), colour = interaction(legal, gender)))  +
  stat_summary(fun.y = sum, geom = "line") +
  scale_x_date(labels = date_format("%Y"), date_breaks= "2 years") +
  ggtitle("Australian adult prisonLF population by state, legal status and gender") +
  theme(plot.title = element_text(size=12)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Year") +
  ylab("Total number of prisonLFers") +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500,
                                5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000,
                                9500, 10000, 10500, 11000, 11500, 12000)) +
  scale_colour_discrete(guide = guide_legend(title = "Legal status & Gender"))+
  facet_grid(.~state)

#
# Generating the bts
#

prison <-read.csv("c:/George/fpp2/Ch10Data/prisonLF.csv", strip.white = TRUE)

prison$state <- as.character(prison$state)
prison$gender <- as.character(prison$gender)

prison$indigenous[prison$indigenous =="3"] <- "2"
prison$indigenous <- as.character(prison$indigenous)

prison$legal[prison$legal =="2"] <- "1"
prison$legal <- as.character(prison$legal)

prison$legal[prison$legal =="3"] <- "2"
prison$legal <- as.character(prison$legal)

prison$legal[prison$legal =="4"] <- "2"
prison$legal <- as.character(prison$legal)

prison$count <- as.numeric(prison$count)

prison <- aggregate(count ~ state + legal + gender + date, data = prison, FUN = sum)

prison_w <- reshape(prison, idvar = c("state", "legal", "gender"), timevar = "date", direction = "wide")

prison_w$pathString <- paste(prison_w$state,#length=1
                          prison_w$legal, #length=1
                          prison_w$gender, #length=1
                          sep="")

#rename the columns
setnames(prison_w, old=c("count.2005/03/01","count.2005/06/01","count.2005/09/01","count.2005/12/01", "count.2006/03/01", "count.2006/06/01", "count.2006/09/01", "count.2006/12/01", "count.2007/03/01", "count.2007/06/01", "count.2007/09/01", "count.2007/12/01", "count.2008/03/01", "count.2008/06/01", "count.2008/09/01", "count.2008/12/01", "count.2009/03/01", "count.2009/06/01", "count.2009/09/01", "count.2009/12/01", "count.2010/03/01", "count.2010/06/01", "count.2010/09/01", "count.2010/12/01", "count.2011/03/01", "count.2011/06/01", "count.2011/09/01", "count.2011/12/01", "count.2012/03/01","count.2012/06/01","count.2012/09/01","count.2012/12/01", "count.2013/03/01", "count.2013/06/01", "count.2013/09/01", "count.2013/12/01", "count.2014/03/01", "count.2014/06/01", "count.2014/09/01", "count.2014/12/01", "count.2015/03/01", "count.2015/06/01", "count.2015/09/01", "count.2015/12/01", "count.2016/03/01","count.2016/06/01","count.2016/09/01","count.2016/12/01"),
         new=c("2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01"))

myvars <- c("pathString","2005/03/01", "2005/06/01", "2005/09/01", "2005/12/01", "2006/03/01", "2006/06/01", "2006/09/01", "2006/12/01", "2007/03/01", "2007/06/01", "2007/09/01", "2007/12/01", "2008/03/01", "2008/06/01", "2008/09/01", "2008/12/01", "2009/03/01", "2009/06/01", "2009/09/01", "2009/12/01", "2010/03/01", "2010/06/01", "2010/09/01", "2010/12/01", "2011/03/01", "2011/06/01", "2011/09/01", "2011/12/01", "2012/03/01", "2012/06/01", "2012/09/01", "2012/12/01", "2013/03/01", "2013/06/01", "2013/09/01", "2013/12/01", "2014/03/01", "2014/06/01", "2014/09/01", "2014/12/01", "2015/03/01", "2015/06/01", "2015/09/01", "2015/12/01", "2016/03/01", "2016/06/01", "2016/09/01", "2016/12/01")
newdata <- prison_w[myvars]

#transpose the data
newdata2 <- t(newdata)

#rename the columns and remove the first row
colnames(newdata2) = newdata2[1,]
newdata2 = newdata2[-1,]

newdata2[newdata2 == 'n/a'] = NA
newdata2 = apply(newdata2, 2, as.numeric)

# write.csv(newdata2, file = "prison.csv",row.names = FALSE)
# data <- read.csv("Ch10Data/prison.csv", strip.white = TRUE, check.names=FALSE)
# data<-newdata2
# bts <- ts(data, start=c(2005,1), end=c(2016,4), frequency=4)
# y.gts <- gts(bts, characters = c(1,1,1))
# ncol(allts(y))
# plot(y.gts[[1]][,1])

library(hts)

prison <- read.csv("Ch10Data/prison.csv", strip.white = TRUE, check.names=FALSE)
prison <- ts(prison, start=c(2005,1), end=c(2016,4), frequency=4)
# Need to make data into prison time series matrix to add to fpp2

# Using the `groups` input # 8 states, 2 legal, 2 gender
s <- rep(c("NSW", "VIC", "QLD", "SA", "WA", "NT", "ACT", "TAS"), 32/8)
l <- rep(rep(c("Rem","Sen"),each=8),2) # Sentenced is number 2 here
g <- rep(c("M","F"),each=32/2)
s_l <- as.character(interaction(s,l,sep=""))
s_g <- as.character(interaction(s,g,sep=""))
g_l <- as.character(interaction(g,l,sep=""))
gc <-rbind(s,l,g,s_l, s_g, g_l)
prison.gts <- gts(prison,groups=gc)


fcsts = forecast(prison.gts, h = 8, method = "comb", weights = "wls", fmethod = "ets")

par(mfrow=c(2,2))

plot(fcsts,levels = 0)
plot(fcsts,levels = 1)
plot(fcsts,levels = 2)
plot(fcsts,levels = 3)
plot(fcsts,levels = 4)
plot(fcsts,levels = 5)
plot(fcsts,levels = 6)
plot(fcsts,levels = 7)


train <- window(prison.gts,end=c(2014,4))
test <- window(prison.gts,start=2015)

fcsts.opt = forecast(train, h = 8, method = "comb", weights = "wls", fmethod = "ets")
fcsts.bu = forecast(train, h = 8, method = "bu", fmethod = "ets")

tab <- matrix(NA,ncol=4,nrow=6)
rownames(tab) <- c("Total", "State", "Legal status", "Gender","Bottom", "All series")
colnames(tab) <- c("Bottom-up MAPE","Bottom-up MASE","Optimal MAPE","Optimal MASE")

tab[1,] <-c(accuracy.gts(fcsts.bu,test,levels = 0)[c("MAPE","MASE"),"Total"],
            accuracy.gts(fcsts.opt,test,levels = 0)[c("MAPE","MASE"),"Total"])

j=2
for(i in c(1:3,7)){
tab[j,] <-c(mean(accuracy.gts(fcsts.bu,test,levels = i)["MAPE",]),
            mean(accuracy.gts(fcsts.bu,test,levels = i)["MASE",]),
            mean(accuracy.gts(fcsts.opt,test,levels = i)["MAPE",]),
            mean(accuracy.gts(fcsts.opt,test,levels = i)["MASE",]))
j=j+1
}

tab[6,] <-c(mean(accuracy.gts(fcsts.bu,test)["MAPE",]),
            mean(accuracy.gts(fcsts.bu,test)["MASE",]),
            mean(accuracy.gts(fcsts.opt,test)["MAPE",]),
            mean(accuracy.gts(fcsts.opt,test)["MASE",]))


knitr::kable(tab, digits=2, booktabs=TRUE)



