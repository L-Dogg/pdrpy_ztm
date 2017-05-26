# Zadaniem tego skryptu jest odfiltrowanie błędnych danych, 
# które mogły się zapisać w analizowanych plikach json na skutek błędu GPS

library(jsonlite)
library(dplyr)
library(lubridate)

source('tools.R')

TRAMS_SOUTH <- 52.118013 - 0.05 # Zajezdnia Kabaty
TRAMS_NORTH <- 52.309925 + 0.05 # Zajezdnia Żoliborz
TRAMS_WEST <- 20.893515 - 0.05 # Os. Górczewska
TRAMS_EAST <- 21.018733 + 0.05 # Żerań Wschodni

#Filters and sorts trams and saves to ($filename)-filtered.json
filter_trams <- function(filename, day_of_month, month) 
{
  trams <- fromJSON(filename)$results %>%
    filter(Lon >= TRAMS_WEST, Lat <= TRAMS_NORTH) %>%
    filter(Lon <= TRAMS_EAST, Lat >= TRAMS_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    filter(month(Time) >= month) %>%
    distinct %>%
    arrange(Time)
  
  output_name <- paste(substring(filename, 1, nchar(filename) - 5), "-filtered.json", sep="")
  write(toJSON(trams, pretty = TRUE), file = output_name)
}

filter_lowfloor_trams <- function(filename, day_of_month, month)
{
  trams <- fromJSON(filename)$results %>% 
    filter(Lon >= TRAMS_WEST, Lat <= TRAMS_NORTH) %>%
    filter(Lon <= TRAMS_EAST, Lat >= TRAMS_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    filter(month(Time) >= month) %>%
    distinct %>%
    arrange(Time)
  
  trams["Hour"] <- hour(sub("T", trams$Time, replacement = " "))
  trams["Minute"] <- minute(sub("T", trams$Time, replacement = " "))
  
  output_name <- paste(substring(filename, 1, nchar(filename) - 5), "-filtered.json", sep="")
  write(toJSON(trams, pretty = TRUE), file = output_name)
}


filter_lowfloor_trams_csv <- function(filename, day_of_month, month)
{
  data <- as.data.frame(read.csv(filename))
  colnames(data) <- c("Time", "Lat", "Lon", "FirstLine", "Lines", "Brigade", "LineBrigade", "Status", "LowFloor")
  trams <- data %>% 
    filter(Lon >= TRAMS_WEST, Lat <= TRAMS_NORTH) %>%
    filter(Lon <= TRAMS_EAST, Lat >= TRAMS_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    filter(month(Time) >= month) %>%
    distinct %>%
    arrange(Time)
  
  trams["Hour"] <- hour(sub("T", trams$Time, replacement = " "))
  trams["Minute"] <- minute(sub("T", trams$Time, replacement = " "))
  
  output_name <- paste(substring(filename, 1, nchar(filename) - 5), "-filtered.json", sep="")
  write(toJSON(trams, pretty = TRUE), file = output_name)
}

filter_lowfloor_trams_csv('data\\2016-03-21\\20160321_tramwaje.csv', 21, 3)
filter_lowfloor_trams_csv('data\\2016-03-22\\20160322_tramwaje.csv', 22, 3)
filter_lowfloor_trams_csv('data\\2016-03-23\\20160323_tramwaje.csv', 23, 3)


BUSES_SOUTH <- 52.080793 # Piaseczno
BUSES_NORTH <- 52.408296 # Legionowo
BUSES_WEST <- 20.833262 # Piastów
BUSES_EAST <- 21.354953 # Halinów

filter_buses <- function(filename, day_of_month, month) 
{
  initial <- fromJSON(filename)$results %>%
    filter(Lon >= BUSES_WEST, Lat <= BUSES_NORTH) %>%
    filter(Lon <= BUSES_EAST, Lat >= BUSES_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    filter(month(Time) >= month) %>%
    distinct %>%
    arrange(Time)
  
  normalLines <- initial %>% filter(Lines %in% NormalBusLines)
  fastPeriodicLines <- initial %>% filter(Lines %in% FastPeriodicBusLines)
  fastLines <- initial %>% filter(Lines %in% FastBusLines)
  zoneLines <- initial %>% filter(Lines %in% ZoneBusLines)
  zoneSupplementaryLines <- initial %>% filter(Lines %in% ZoneSupplementaryBusLines)
  zonePeriodicLines <- initial %>% filter(Lines %in% ZonePeriodicBusLines)
  specialLines <- initial %>% filter(Lines %in% SpecialBusLines)
  expressLines <- initial %>% filter(Lines %in% ExpressBusLines)
  nightLines <- initial %>% filter(Lines %in% NightBusLines)

  filteredLines <- list(initial, normalLines, fastPeriodicLines, fastLines, zoneLines, zoneSupplementaryLines, zonePeriodicLines,
                     specialLines, expressLines, nightLines)

  fileSuffixes <- c("initial", "normal", "fast-periodic", "fast", "zone", "zone-supplementary", "zone-periodic", "special",
                    "express", "night")


  result <- sapply(1:length(filteredLines), function (i) { saveToFile(filteredLines[[i]], filename, fileSuffixes[i])})
    
}

saveToFile <- function (data, filepath, fileSuffix) 
{
  output_name <- paste(substring(filepath, 1, nchar(filepath) - 5), "-", fileSuffix, "-filtered.json", sep="")
  write(toJSON(data, pretty = TRUE), file = output_name)
}

filter_buses("data\\14-05\\buses.json", 14, 5)
filter_buses("data\\14-05\\buses2.json", 14, 5)
filter_buses("data\\14-05\\buses3.json", 14, 5)
filter_buses("data\\15-05\\buses3.json", 15, 5)

filter_trams("data\\14-05\\trams.json", 14, 5)
filter_trams("data\\14-05\\trams2.json", 14, 5)
filter_trams("data\\14-05\\trams3.json", 14, 5)
filter_trams("data\\15-05\\trams3.json", 15, 5)