library(jsonlite)
library(dplyr)

setwd("H:\\PDRPy\\pd4\\pdrpy_ztm")
source("tools.R")

filenames14night <- list.files("data\\14-05\\buses-initial-filtered", pattern="*.json", full.names=TRUE)
filenames14night <- c(filenames14night, list.files("data\\14-05\\buses2-initial-filtered", 
                                                 pattern="*.json", full.names=TRUE))
filenames14day <- list.files("data\\14-05\\buses3-initial-filtered",
                                     pattern="*.json", full.names=TRUE)

filenames15day <- list.files("data\\15-05\\buses3-initial-filtered",
                                           pattern="*.json", full.names=TRUE)

tramsFilenames14night <- list.files("data\\14-05\\trams-filtered", pattern="*.json", full.names=TRUE)
tramsFilenames14night <- c(tramsFilenames14night, list.files("data\\14-05\\trams2-filtered", pattern="*.json", full.names=TRUE))

tramsFilenames14day <- list.files("data\\14-05\\trams3-filtered", pattern="*.json", full.names=TRUE)

tramsFilenames15 <- list.files("data\\15-05\\trams3-filtered", pattern="*.json", full.names=TRUE)

tramsFilenames20160321 <- list.files("data\\2016-03-21\\20160321_tramwaj-filtered", pattern="*.json", full.names=TRUE)
tramsFilenames20160322 <- list.files("data\\2016-03-22\\20160322_tramwaj-filtered", pattern="*.json", full.names=TRUE)
tramsFilenames20160323 <- list.files("data\\2016-03-23\\20160323_tramwaj-filtered", pattern="*.json", full.names=TRUE)

totalDistance <- 0

calculateDistance <- function(files, resultFile) {
totalDistance <- sum(sapply(files, function (filename) {
  df <- fromJSON(filename)
  df <- as.data.frame(df$res)
  if (nrow(df) > 1) {
    sum(sapply(2:(nrow(df)), function (i, df) {
      coordinatesToMeters(df$Lat[i], df$Lon[i], df$Lat[i-1], df$Lon[i-1])
    }, df))
  }
  else {
    0
  }
}))

write(toJSON(totalDistance, pretty=TRUE), file = resultFile)
}

calculateDistance(filenames14night, 'data\\14-05\\busDistance-night.json')
calculateDistance(filenames14day, 'data\\14-05\\busDistance-day.json')
calculateDistance(filenames15day, 'data\\15-05\\busDistance-day.json')

calculateDistance(tramsFilenames14day, 'data\\14-05\\tramsDistance-day.json')
calculateDistance(tramsFilenames14night, 'data\\14-05\\tramsDistance-night.json')
calculateDistance(tramsFilenames15, 'data\\15-05\\tramsDistance.json')
calculateDistance(tramsFilenames20160321, 'data\\2016-03-21\\tramsDistance.json')
calculateDistance(tramsFilenames20160322, 'data\\2016-03-22\\tramsDistance.json')
calculateDistance(tramsFilenames20160323, 'data\\2016-03-23\\tramsDistance.json')