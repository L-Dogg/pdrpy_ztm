library(jsonlite)
library(dplyr)

setwd("H:\\PDRPy\\pd4\\pdrpy_ztm")

filenames14night <- list.files("data\\14-05\\buses-initial-filtered", pattern="*.json", full.names=TRUE)
filenames14night <- c(filenames14night, list.files("data\\14-05\\buses2-initial-filtered", 
                                                 pattern="*.json", full.names=TRUE))
filenames14day <- list.files("data\\14-05\\buses3-initial-filtered",
                                     pattern="*.json", full.names=TRUE)

filenames15day <- list.files("data\\15-05\\buses3-initial-filtered",
                                           pattern="*.json", full.names=TRUE)

totalDistance <- 0

distance <- function(lat1, lon1, lat2, lon2){  
  R <- 6378.137;
  dLat <- lat2 * pi / 180 - lat1 * pi / 180;
  dLon <- lon2 * pi / 180 - lon1 * pi / 180;
  a <- sin(dLat/2) * sin(dLat/2) +
    cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
    sin(dLon/2) * sin(dLon/2);
  c <- 2 * atan2(sqrt(a), sqrt(1-a));
  d <- R * c;
  d * 1000;
}

calculateDistance <- function(files, resultFile) {
totalDistance <- sum(sapply(files, function (filename) {
  df <- fromJSON(filename)
  df <- as.data.frame(df$res)
  if (nrow(df) > 1) {
    sum(sapply(2:(nrow(df)), function (i, df) {
      distance(df$Lat[i], df$Lon[i], df$Lat[i-1], df$Lon[i-1])
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