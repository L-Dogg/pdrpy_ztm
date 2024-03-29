library(jsonlite)
library(dplyr)
source('tools.R')

groupSpeed <- function (filename, isDay) {
  data <- fromJSON(filename)
  baseDir <- substring(filename, 1, nchar(filename) - 5)
  if (isDay) {
    normalLines <- data %>% filter(Line %in% NormalBusLines)
    zoneLines <- data %>% filter(Line %in% ZoneBusLines)
    fastLines <- data %>% filter(Line %in% FastBusLines)
    fastPeriodicLines <- data %>% filter(Line %in% FastPeriodicBusLines)
    nightLines <- NA
    names <- c("Zwykle", "Strefowe", "Przyspieszone", "Przyspieszone okresowe")
    speed <- c(mean(normalLines$V), mean(zoneLines$V), mean(fastLines$V), mean(fastPeriodicLines$V))
    write(toJSON(data.frame(Type=names, V=speed), pretty=TRUE), 
                 file = paste(baseDir, '-grouped.json', sep=''))
  }
  else {
    nightLines <- data %>% filter(Line %in% NightBusLines)
    names <- "Nocne"
    write(toJSON(data.frame(Type=names, V=mean(nightLines$V)), pretty=TRUE), 
          file = paste(baseDir, '-grouped.json', sep=''))
  }
}


groupSpeed('data\\14-05\\busSpeed-day.json', TRUE)
groupSpeed('data\\14-05\\busSpeed-night.json', FALSE)
groupSpeed('data\\15-05\\busSpeed-day.json', TRUE)