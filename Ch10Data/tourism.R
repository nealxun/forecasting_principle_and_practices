require(tidyverse)
require(reshape2)
require(hts)
require(zoo)

tmp <- read_csv("c:/george/fpp2/Ch10Data/tourism.csv")
head(tmp)

AUS <- colnames(tmp)[c(3:78)]

NSW <- colnames(tmp)[3:15] # these were just used for checks to start with

NSWMet <- c("Sydney",
            "Central Coast")

NSWNtC <- c("Hunter",
            "North Coast NSW")
NSWStC <- "South Coast"

NSWSth <- c("Snowy Mountains",
            "Capital Country",
            "The Murray",
            "Riverina")

NSWNth <- c("Blue Mountains",
            "Central NSW",
            "New England North West",
            "Outback NSW")

VIC <- colnames(tmp)[16:36]

VICMet <- c("Melbourne",
            "Peninsula",
            "Geelong")

VICWtC <- "Western"
VICEtC <- c("Lakes",
            "Gippsland",
            "Phillip Island")

VICInd <- c("Central Murray",
            "Goulburn",
            "High Country",
            "Melbourne East",
            "Upper Yarra",
            "Murray East",
            "Wimmera",
            "Mallee",
            "Western Grampians",
            "Bendigo Loddon",
            "Macedon",
            "Spa Country",
            "Ballarat",
            "Central Highlands")

QLD <- colnames(tmp)[37:48]

QLDMet <- c("Gold Coast",
            "Brisbane",
            "Sunshine Coast")
QLDCtl <- c("Central Queensland",
            "Bundaberg",
            "Fraser Coast",
            "Mackay",
            "Darling Downs",
            "Outback")

QLDNth <- c("Whitsundays",
            "Northern",
            "Tropical North Queensland")


WAUMet <- c("Experience Perth")

WAUCst <- c("Australia's Coral Coast",
            "Australia's North West",
            "Australia's South West")

WAUInd <- c("Australia's Golden Outback")

SAUMet <- c("Adelaide",
            "Barossa",
            "Adelaide Hills")

SAUCst <- c("Limestone Coast" ,
            "Fleurieu Peninsula",
            "Kangaroo Island",
            "Eyre Peninsula",
            "Yorke Peninsula"
            )

SAUInd <- c("Murraylands",
            "Riverland",
            "Clare Valley",
            "Flinders Ranges and Outback")


OTHMet <- c("Canberra",
            "Hobart and the South",
            "Darwin",
            "Alice Springs")

OTHNot <- dplyr::setdiff(AUS, c(NSWMet, NSWNtC, NSWStC, NSWSth, NSWNth,
                                VICMet, VICWtC, VICEtC, VICInd,
                                QLDMet, QLDCtl, QLDNth,
                                WAUMet, WAUCst, WAUInd,
                                SAUMet, SAUCst, SAUInd, OTHMet
                                ))


tourism <- tmp %>%
  transmute(Year, Month) %>%
  mutate(`NSWMetro` = rowSums(tmp[, NSWMet]),
         `NSWNthCo` = rowSums(tmp[, NSWNtC]),
         `NSWSthCo` = rowSums(tmp[, NSWStC]),
         `NSWSthIn` = rowSums(tmp[, NSWSth]),
         `NSWNthIn` = rowSums(tmp[, NSWNth]),
         `QLDMetro` = rowSums(tmp[, QLDMet]),
         `QLDCntrl` = rowSums(tmp[, QLDCtl]),
         `QLDNthCo` = rowSums(tmp[, QLDNth]),
         `SAUMetro` = rowSums(tmp[, SAUMet]),
         `SAUCoast` = rowSums(tmp[, SAUCst]),
         `SAUInner` = rowSums(tmp[, SAUInd]),
         `VICMetro` = rowSums(tmp[, VICMet]),
         `VICWstCo` = rowSums(tmp[, VICWtC]),
         `VICEstCo` = rowSums(tmp[, VICEtC]),
         `VICInner` = rowSums(tmp[, VICInd]),
         `WAUMetro` = rowSums(tmp[, WAUMet]),
         `WAUCoast` = rowSums(tmp[, WAUCst]),
         `WAUInner` = rowSums(tmp[, WAUInd]),
         `OTHMetro` = rowSums(tmp[, OTHMet]),
         `OTHNoMet` = rowSums(tmp[, OTHNot]))

chk <- tourism[, 3:ncol(tourism)]
bts <- ts(apply(chk, 2, function(x) aggregate(ts(x, start = 1998, frequency = 12), nfrequency = 4)), start = 1998, frequency = 4)

#write.csv(bts, "vn2.csv",row.names = FALSE)

require(hts)
require(fpp2)
bts <- read.csv("vn2.csv")
bts <- ts(bts, start = 1998, frequency = 4)

# bts<-window(bts,start=c(2008,2))
# tourism.hts <- hts(bts, nodes=list(4,c(5, 4, 5, 2)))

tourism.hts <- hts(bts, characters = c(3, 5))



# Top Level
tourismL0 <- aggts(tourism.hts, levels = 0)
#
p1<-autoplot(tourismL0) +
  xlab("Year") +
  ylab("Visitor nights ('000)")+
  ggtitle("Total")

time <- tibble(Time = zoo::as.Date(tourismL0))
datL0 <- bind_cols(time, as_tibble(tourismL0))
ggplot(datL0) +
  geom_line(aes(x = Time, y = as.numeric(Total))) +
  xlab("Time") + ylab("Visitor nights ('000)") +
  guides(colour = FALSE)

# Level 1

tourismL1 <- aggts(tourism.hts, levels = 1)
p2<-autoplot(tourismL1[,c(1,3,5)]) +
   xlab("Year") +
   ylab("Visitor nights ('000)")+
   scale_colour_discrete(guide = guide_legend(title = "State"))

p3<-autoplot(tourismL1[,c(2,4,6)]) +
   xlab("Year") +
   ylab("Visitor nights ('000)")+
   scale_colour_discrete(guide = guide_legend(title = "State"))

 lay=rbind(c(1,1),c(2,3))
 gridExtra::grid.arrange(p1, p2,p3, layout_matrix=lay)

# datL1 <- bind_cols(time, as_tibble(tourismL1))
# meltL1 <- melt(datL1, id = "Time")
# # meltL1$variable <- factor(meltL1$variable, levels = c("NSW", "VIC", "QLD", "OTH"))
# ggplot(meltL1) + geom_line(aes(x= Time, y = as.numeric(value), group = variable, color = variable)) +
#   scale_colour_discrete(guide = guide_legend(title = "States")) +
#   xlab("Time") + ylab("Visitor nights ('000)")

# Level 2

tourismL2 <- aggts(tourism.hts, levels = 2)
time <- tibble(Time = zoo::as.Date(tourismL2))
nodes <- tourism.hts$nodes
nodesB <- as.numeric(nodes[[length(nodes)]], deparse = FALSE)
ends <- cumsum(nodesB)
start <- c(1, ends[1:(length(nodesB) - 1)] + 1)
time <- tibble(Time = zoo::as.Date(tourismL2))


plotsL2 <- list()


#i=1
for(i in 1:length(start))
{
  datL2 <- bind_cols(time, as_tibble(tourismL2[, start[i]:ends[i]]))
  meltL2 <- melt(datL2, id = "Time")
  plotsL2[[i]] <-   ggplot(meltL2) + geom_line(aes(x= Time, y = as.numeric(value), group = variable, color = variable)) +
    scale_colour_discrete(guide = guide_legend(title = "Region")) +
    xlab("Time") + ylab("Visitor nights ('000)")
}

plotsL2[[1]]
plotsL2[[2]]
plotsL2[[3]]
plotsL2[[4]]
plotsL2[[5]]
plotsL2[[6]]



fcsts.bu<-forecast.gts(tourism.hts,h=8,method="bu",fmethod = "arima")
plot(fcsts.bu,levels = 0,include=40)
plot(fcsts.bu,levels = 1,include=40)
plot(fcsts.bu,levels = 2,include=40)

autoplot(allts(fcsts.bu)[,1])+
  geom_point()

# no trend in the forecasts although the top level historical
# series shows growth over the last few years

fit <-auto.arima(allts(tourism.hts)[,1])
autoplot(forecast(fit,h=8))

# The arima model fittd at the top series includes
# drift - hence forecasting at the top level alone
# we would get upward trending forecasts

fcsts.comb<-forecast.gts(tourism.hts,h=8,method="comb",fmethod = "arima")
plot(fcsts.comb,levels = 0,include=40)
plot(fcsts.comb,levels = 1,include=40)
plot(fcsts.comb,levels = 2,include=40)


autoplot(allts(fcsts.comb)[,1])+
  geom_point()+
  autolayer(allts(fcsts.bu)[,1],series = "BU")

autoplot(allts(fcsts.comb)[,2:7])+
  geom_point()+
  autolayer(allts(fcsts.bu)[,2:7])


autoplot(allts(fcsts.comb)[,1])+
  geom_point()+
  forecast::autolayer(allts(fcsts.bu)[,1], series="BU")+
  forecast::autolayer(f.arima,PI=FALSE, series="ets")


h <- 8
ally <- aggts(tourism.hts)
allf <- matrix(NA, nrow = h, ncol = ncol(ally))
for(i in 1:ncol(ally))
  allf[,i] <- forecast(auto.arima(ally[,i]), h = h)$mean
allf <- ts(allf, start = 2017, frequency = 4)
fcsts.arima <- combinef(allf, get_nodes(tourism.hts), weights = NULL, keep = "gts", algorithms = "lu")
plot(fcsts.arima,levels = 0)

autoplot(allts(fcsts.comb)[,1])+
  geom_point()+
  forecast::autolayer(allts(fcsts.bu)[,1], series="BU")+
  forecast::autolayer(allts(fcsts.arima)[,1], series="arima")

autoplot(allts(fcsts.comb)[,2:7])+
  geom_point()+
  autolayer(allts(fcsts.bu)[,2:7])+
  autolayer(allts(fcsts.arima)[,2:7])


train <- window(tourism.hts,end=c(2014,4))
test <- window(tourism.hts,start=2015)


fcsts.opt = forecast(train, h = 8, method = "comb", weights = "mint", fmethod = "arima")
fcsts.td = forecast(train, h = 8, method = "tdfp", fmethod = "arima")
fcsts.bu = forecast(train, h = 8, method = "bu", fmethod = "arima")

plot(fcsts.td)

tab <- matrix(NA,ncol=6,nrow=4)
rownames(tab) <- c("Total", "State", "Zones","All series")
colnames(tab) <- c("BU MAPE","BU MASE","TD MAPE","TD MASE","Opt MAPE","Opt MASE")

tab[1,] <-c(accuracy.gts(fcsts.bu,test,levels = 0)[c("MAPE","MASE"),"Total"],
            accuracy.gts(fcsts.td,test,levels = 0)[c("MAPE","MASE"),"Total"],
            accuracy.gts(fcsts.opt,test,levels = 0)[c("MAPE","MASE"),"Total"])

j=2
for(i in c(1:2)){
  tab[j,] <-c(mean(accuracy.gts(fcsts.bu,test,levels = i)["MAPE",]),
              mean(accuracy.gts(fcsts.bu,test,levels = i)["MASE",]),
              mean(accuracy.gts(fcsts.td,test,levels = i)["MAPE",]),
              mean(accuracy.gts(fcsts.td,test,levels = i)["MASE",]),
              mean(accuracy.gts(fcsts.opt,test,levels = i)["MAPE",]),
              mean(accuracy.gts(fcsts.opt,test,levels = i)["MASE",]))
  j=j+1
}

tab[4,] <-c(mean(accuracy.gts(fcsts.bu,test)["MAPE",]),
            mean(accuracy.gts(fcsts.bu,test)["MASE",]),
            mean(accuracy.gts(fcsts.td,test)["MAPE",]),
            mean(accuracy.gts(fcsts.td,test)["MASE",]),
            mean(accuracy.gts(fcsts.opt,test)["MAPE",]),
            mean(accuracy.gts(fcsts.opt,test)["MASE",]))



