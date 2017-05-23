library(dplyr)
library(lubridate)
library(jsonlite)

#Ochota:
OCHOTA_PATTERN = "^(7|9)"
KOROTYNSKIEGO_LAT = 52.202597
KOROTYNSKIEGO_LON = 20.969198

#Mokotów:
MOKOTOW_PATTERN = "^17"
MOKOTOW_LAT = 52.189607
MOKOTOW_LON = 21.002015

#Żoliborz:
ZOLIBORZ_PATTERN = "^17"
MARYMONT_LAT = 52.271886
MARYMONT_LON = 20.971979

#Bemowo:
BEMOWO_PATTERN = "^24"
BEMOWO_LAT = 52.251406
BEMOWO_LON = 20.914978

#Bródno:
BRODNO_PATTERN = "^(25|4)"
BRODNO_LAT = 52.288691
BRODNO_LON = 21.030294

#Docelowe:
CENTRUM_LAT = 52.229433
CENTRUM_LON = 21.009972
CENTRALNY_LAT = 52.228482
CENTRALNY_LON = 21.001546

dirpath = "data/15-05/trams3-filtered/"

get_times_north <- function(start_lat, start_lon, end_lat, end_lon, 
                      pattern, min_time = 10, max_time=40, offset = 0.00025)
{
  times = 0
  filenames = dir(dirpath, pattern=pattern)
  k = 1
  
  for (i in 1:length(filenames))
  {
    stop_arrivals <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
      filter(abs(start_lat - Lat) <= offset) %>%
      filter(hour(Time) >= 8, hour(Time) < 10)
    
    if (nrow(stop_arrivals) > 0)
    {
      for (j in 1:length(stop_arrivals))
      {
        arrival_time = stop_arrivals$Time[j]
        data_between_stops <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
          filter(Time >= arrival_time) %>%
          filter(hour(Time) <= 11) %>%
          filter(Lat - start_lat >= 0) %>%
          filter(Lat - end_lat <= 0) %>%
          filter(row_number() == 1 | row_number() == n())
        
        times[k] = difftime(data_between_stops$Time[2], data_between_stops$Time[1])
        k = k +1
      }
    }
  }
  
  times = times[!is.na(times)]
  times = times[times > min_time & times < max_time]
}

get_times_south <- function(start_lat, start_lon, end_lat, end_lon, 
                            pattern, min_time = 10, max_time=40, offset = 0.00025)
{
  times = 0
  filenames = dir(dirpath, pattern=pattern)
  k = 1
  
  for (i in 1:length(filenames))
  {
    stop_arrivals <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
      filter(abs(start_lat - Lat) <= offset) %>%
      filter(hour(Time) >= 8, hour(Time) < 10)
    
    if (nrow(stop_arrivals) > 0)
    {
      for (j in 1:length(stop_arrivals))
      {
        arrival_time = stop_arrivals$Time[j]
        data_between_stops <- fromJSON(paste(dirpath, filenames[i], sep=""))$res[[1]] %>%
          filter(Time >= arrival_time) %>%
          filter(hour(Time) <= 11) %>%
          filter(Lat - start_lat <= 0) %>%
          filter(Lat - end_lat >= 0) %>%
          filter(row_number() == 1 | row_number() == n())
        
        times[k] = difftime(data_between_stops$Time[2], data_between_stops$Time[1])
        k = k +1
      }
    }
  }
  
  times = times[!is.na(times)]
  times = times[times > min_time & times < max_time]
}