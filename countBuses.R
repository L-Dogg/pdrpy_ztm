library(jsonlite)
library(dplyr)

setwd("H:\\PDRPy\\pd4\\pdrpy_ztm")


countBuses <- function (df, outputFile) {
  buses <- df %>% group_by(Brigade, Lines) %>% summarise(n())
  write(toJSON(nrow(buses), pretty=TRUE), file = outputFile)
}

normalBuses14 <- rbind(fromJSON('data\\14-05\\buses-normal-filtered.json'), fromJSON('data\\14-05\\buses2-normal-filtered.json'),
                       fromJSON('data\\14-05\\buses3-normal-filtered.json'))

fastBuses14 <- rbind(fromJSON('data\\14-05\\buses-fast-filtered.json'),fromJSON('data\\14-05\\buses2-fast-filtered.json'),
                     fromJSON('data\\14-05\\buses3-fast-filtered.json'))

fastBuses15 <- fromJSON('data\\15-05\\buses3-fast-filtered.json')

fastPeriodicBuses14 <- rbind(fromJSON('data\\14-05\\buses2-fast-periodic-filtered.json'), 
                             fromJSON('data\\14-05\\buses3-fast-periodic-filtered.json'))

fastPeriodicBuses15 <- fromJSON('data\\15-05\\buses3-fast-periodic-filtered.json')

zoneBuses14 <- rbind(fromJSON('data\\14-05\\buses-zone-filtered.json'),fromJSON('data\\14-05\\buses2-zone-filtered.json'),
                     fromJSON('data\\14-05\\buses3-zone-filtered.json'))


zoneBuses15 <- fromJSON('data\\15-05\\buses3-zone-filtered.json')

normalBuses15 <- fromJSON('data\\15-05\\buses3-normal-filtered.json')

nightBuses14 <- rbind(fromJSON('data\\14-05\\buses-night-filtered.json'), 
                      fromJSON('data\\14-05\\buses2-night-filtered.json'))

countBuses(normalBuses14, 'data\\14-05\\busesNormalCount.json')
countBuses(fastBuses14, 'data\\14-05\\busesFastCount.json')
countBuses(fastPeriodicBuses14, 'data\\14-05\\busesFastPeriodicCount.json')
countBuses(zoneBuses14, 'data\\14-05\\busesZoneCount.json')
countBuses(nightBuses14, 'data\\14-05\\busesNightCount.json')
countBuses(normalBuses15, 'data\\15-05\\busesNormalCount.json')
countBuses(fastBuses15, 'data\\15-05\\busesFastCount.json')
countBuses(fastPeriodicBuses15, 'data\\15-05\\busesFastPeriodicCount.json')
countBuses(zoneBuses15, 'data\\15-05\\busesZoneCount.json')