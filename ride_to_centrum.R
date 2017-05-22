library(dplyr)
library(lubridate)
library(jsonlite)

KOROTYNSKIEGO_LAT = 52.202597
KOROTYNSKIEGO_LON = 20.969198

WORONICZA_LAT = 52.188534
WORONICZA_LON = 21.002015

CENTRUM_LAT = 52.229433
CENTRUM_LON = 21.009972

CENTRALNY_LAT = 52.228482
CENTRALNY_LON = 21.001546

OFFSET = 0.0001

dirpath = "data/15-05/trams3-filtered/"

get_times <- function(start_lat, start_lon,  end_lat, end_lon, pattern)
{
  filenames = dir(dirpath, pattern=pattern)
  k = 1
  
  for (i in 1:length(filenames))
  {
    stop_arrivals <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
      filter(abs(start_lat - Lat) <= OFFSET) %>%
      filter(hour(Time) >= 8, hour(Time) < 10)
    
    for (j in 1:length(stop_arrivals))
    {
      arrival_time = stop_arrivals$Time[j]
      data_between_stops <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
        filter(Time > arrival_time) %>%
        filter(hour(Time) <= 11) %>%
        filter(Lat - start_lat >= 0) %>%
        filter(Lat - end_lat <= 0) %>%
        filter(row_number() == 1 | row_number() == n())
      
      times[k] = difftime(data_between_stops$Time[2], data_between_stops$Time[1])
      k = k +1
    }
  }
  
  times = times[!is.na(times)]
  times = times[times > 10 & times < 35]
}