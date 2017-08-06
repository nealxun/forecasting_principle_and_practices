tmp <- read_csv("C:/George/fpp2/Ch10Data/tourism.csv")
head(tmp)

AUS <- colnames(tmp)[c(3:78)]

NSW <- colnames(tmp)[c(3:15, 78)] # these were just used for checks to start with

MetNSW <- c("Sydney",
              "Central Coast")
NthNSW <- c("Hunter",
            "North Coast NSW",
            "Blue Mountains",
            "Central NSW",
            "New England North West",
            "Outback NSW")
SthNSW <- c("South Coast",
            "Capital Country",
            "Riverina",
            "Snowy Mountains",
            "The Murray")
OthNSW <- dplyr::setdiff(NSW, c(MetNSW, NthNSW, SthNSW))

VIC <- colnames(tmp)[16:36]
MetVIC <- c("Melbourne",
            "Peninsula",
            "Geelong")
WstVIC <- c("Western",
            "Wimmera",
            "Mallee",
            "Western Grampians",
            "Bendigo Loddon",
            "Macedon",
            "Spa Country",
            "Ballarat",
            "Central Highlands")

EstVIC <- c("Lakes",
            "Gippsland",
            "Phillip Island",
            "Central Murray",
            "Goulburn",
            "High Country",
            "Melbourne East",
            "Upper Yarra",
            "Murray East")

QLD <- colnames(tmp)[37:48]
MetQLD <- c("Gold Coast",
              "Brisbane",
              "Sunshine Coast")
CtlQLD <- c("Central Queensland",
            "Bundaberg",
            "Fraser Coast",
            "Mackay",
            "Darling Downs",
            "Outback")
NthQLD <- c("Whitsundays",
            "Northern",
            "Tropical North Queensland")

OthAUS <- dplyr::setdiff(AUS, c(MetNSW, NthNSW, SthNSW,
                             MetVIC,EstVIC,WstVIC,
                             MetQLD,CtlQLD,NthQLD))

OthMet <- c("Canberra",
            "Adelaide",
            "Barossa",
            "Adelaide Hills",
            "Experience Perth",
            "Hobart and the South",
            "Darwin",
            "Alice Springs")

Oth <- dplyr::setdiff(AUS, c(MetNSW, NthNSW, SthNSW,
                                MetVIC,EstVIC,WstVIC,
                                MetQLD,CtlQLD,NthQLD,OthMet))


zonesData <- tmp %>%
  transmute(Year, Month) %>%
  mutate(`MetNSW` = rowSums(tmp[, MetNSW]),
         `NthNSW` = rowSums(tmp[, NthNSW]),
         `SthNSW` = rowSums(tmp[, SthNSW]),
         `MetVIC` = rowSums(tmp[, MetVIC]),
         `WstVIC` = rowSums(tmp[, WstVIC]),
         `EstVIC` = rowSums(tmp[, EstVIC]),
         `MetQLD` = rowSums(tmp[, MetQLD]),
         `CtlQLD` = rowSums(tmp[, CtlQLD]),
         `NthQLD` = rowSums(tmp[, NthQLD]),
         `OthMet` = rowSums(tmp[, OthMet]),
         `Oth` = rowSums(tmp[, Oth]))

#save(zones, file = "zones.Rdata")

write.csv(zonesData, )

