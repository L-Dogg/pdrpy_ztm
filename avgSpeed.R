library(jsonlite)
library(dplyr)
library(lubridate)


filenames14night <- list.files("data\\14-05\\buses-initial-filtered", pattern="*.json", full.names=TRUE)

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

result <- do.call(rbind, lapply(filenames14night, function (file) {
  df <- fromJSON(file)
  df <- as.data.frame(df$res)
  results <- NA
  if (nrow(df) > 1) {
    results <- sapply(2:nrow(df), function (i, df) {
      dist <- distance(df$Lat[i], df$Lon[i], df$Lat[i-1], df$Lon[i-1])
      time <- as.numeric(difftime(df$Time[i],df$Time[i-1],units="secs"))
      dist/time
    }, df)
  }
  
  avgSpeed <- NA
  if (length(results) > 1) {
    avgSpeed <- mean(results, na.rm=TRUE)
  }
  c(df$Lines[1], avgSpeed)
}))

result <- as.data.frame(result)
colnames(result) <- c("Line", "V")

wrapper <- function(df) {
  df %>% as.data.frame %>% return
}
resultGrouped <- result %>% filter(!is.infinite(V)) %>% filter(!is.na(V)) %>% group_by(Line) %>% summarise(avg = mean(V))

resultGrouped
