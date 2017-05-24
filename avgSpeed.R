library(jsonlite)
library(dplyr)
library(lubridate)

setwd("H:\\PDRPy\\pd4\\pdrpy_ztm")

source("tools.R")

filenames14night <- list.files("data\\14-05\\buses-initial-filtered", pattern="*.json", full.names=TRUE)
filenames14night <- c(filenames14night, list.files("data\\14-05\\buses2-initial-filtered", 
                                                   pattern="*.json", full.names=TRUE))

filenames14day <- list.files("data\\14-05\\buses3-initial-filtered",
                             pattern="*.json", full.names=TRUE)

filenames15day <- list.files("data\\15-05\\buses3-initial-filtered",
                             pattern="*.json", full.names=TRUE)

calculateSpeed <- function (files, resultFile) {

  result <- do.call(rbind, lapply(files, function (file) {
    df <- fromJSON(file)
    df <- as.data.frame(df$res)
    results <- NA
    if (nrow(df) > 1) {
      results <- sapply(2:nrow(df), function (i, df) {
        dist <- coordinatesToMeters(df$Lat[i], df$Lon[i], df$Lat[i-1], df$Lon[i-1])
        time <- as.numeric(difftime(df$Time[i],df$Time[i-1],units="secs"))
        if(dist == 0) {
         NA
        }
        else {
          dist/time
        }
      }, df)
    }
  
    avgSpeed <- NA
    if (length(results) > 1) {
      avgSpeed <- mean(results, na.rm=TRUE)
    }
    c(df$Lines[1], avgSpeed)
  }))

  result <- data.frame(Line = result[,1], V = as.numeric(as.character(result[, 2])))

  resultGrouped <- result %>% 
    filter(!is.infinite(V)) %>% 
    filter(!is.na(V)) %>% 
    group_by(Line) %>% 
    summarise(mean(V, na.rm=TRUE) * 3.6)

  colnames(resultGrouped) <- c("Line", "V")
  
  resultGrouped <- resultGrouped %>% filter(V < 100)
  write(toJSON(resultGrouped, pretty=TRUE), file = resultFile)
}

calculateSpeed(filenames14night, 'data\\14-05\\busSpeed-night.json')
calculateSpeed(filenames14day, 'data\\14-05\\busSpeed-day.json')
calculateSpeed(filenames15day, 'data\\15-05\\busSpeed-day.json')
