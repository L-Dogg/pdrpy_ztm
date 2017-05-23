library(dplyr)
library(lubridate)
library(jsonlite)

#Ochota: north
OCHOTA_PATTERN = "^(7|9)"
OCHOTA_LAT = 52.202597
OCHOTA_LON = 20.969198

#Mokotów: north
MOKOTOW_PATTERN = "^17"
MOKOTOW_LAT = 52.189607
MOKOTOW_LON = 21.002015

#Żoliborz: south
ZOLIBORZ_PATTERN = "^17"
ZOLIBORZ_LAT = 52.271886
ZOLIBORZ_LON = 20.971979

#Bemowo: east
BEMOWO_PATTERN = "^24"
BEMOWO_LAT = 52.251406
BEMOWO_LON = 20.914978

#Bródno: south
BRODNO_PATTERN = "^(25|4)"
BRODNO_LAT = 52.288691
BRODNO_LON = 21.030294

#Praga: west
PRAGA_PATTERN = "^(9|24)"
PRAGA_LAT = 52.242358
PRAGA_LON = 21.102894

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

get_times_west <- function(start_lat, start_lon, end_lat, end_lon, 
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
          filter(Lon - start_lon <= 0) %>%
          filter(Lon - end_lon >= 0) %>%
          filter(row_number() == 1 | row_number() == n())
        
        times[k] = difftime(data_between_stops$Time[2], data_between_stops$Time[1])
        k = k +1
      }
    }
  }
  
  times = times[!is.na(times)]
  times = times[times > min_time & times < max_time]
}

get_times_east <- function(start_lat, start_lon, end_lat, end_lon, 
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
          filter(Lon - start_lon >= 0) %>%
          filter(Lon - end_lon <= 0) %>%
          filter(row_number() == 1 | row_number() == n())
        
        times[k] = difftime(data_between_stops$Time[2], data_between_stops$Time[1])
        k = k +1
      }
    }
  }
  
  times = times[!is.na(times)]
  times = times[times > min_time & times < max_time]
}

generate_time_data <- function(directory) {
  ets = c("Ochota", "Mokotów", "Żoliborz", "Bemowo", "Bródno", "Praga")
  ochota <- get_times_north(OCHOTA_LAT, OCHOTA_LON, CENTRALNY_LAT, CENTRALNY_LON, OCHOTA_PATTERN)
  mokotow <- get_times_north(MOKOTOW_LAT, MOKOTOW_LON, CENTRALNY_LAT, CENTRALNY_LON, MOKOTOW_PATTERN)
  zoliborz <- get_times_south(ZOLIBORZ_LAT, ZOLIBORZ_LON, CENTRALNY_LAT, CENTRALNY_LON, ZOLIBORZ_PATTERN)
  bemowo <- get_times_east(BEMOWO_LAT, BEMOWO_LON, CENTRALNY_LAT, CENTRALNY_LON, BEMOWO_PATTERN)
  brodno <- get_times_south(BRODNO_LAT, BRODNO_LON, CENTRALNY_LAT, CENTRALNY_LON, BRODNO_PATTERN)
  praga <- get_times_west(PRAGA_LAT, PRAGA_LON, CENTRALNY_LAT, CENTRALNY_LON, PRAGA_PATTERN, offset = 0.0015, min_time = 15)
  
  vals <- list(ochota, mokotow, zoliborz, bemowo, brodno, praga)
  max_len = max(sapply(vals, length))
  df = data.frame(sapply(vals, function(x){x = c(x, rep(NA, max_len - length(x)))}))
  colnames(df) <- ets
  
  write.csv(df, paste(directory, "time-data.csv", sep=""), na='', row.names = FALSE)
}