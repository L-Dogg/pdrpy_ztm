# Zadaniem tego skryptu jest odfiltrowanie błędnych danych, 
# które mogły się zapisać w analizowanych plikach json na skutek błędu GPS

library(jsonlite)
library(dplyr)
library(lubridate)

TRAMS_SOUTH <- 52.118013 - 0.05 # Zajezdnia Kabaty
TRAMS_NORTH <- 52.309925 + 0.05 # Zajezdnia Żoliborz
TRAMS_WEST <- 20.893515 - 0.05 # Os. Górczewska
TRAMS_EAST <- 21.018733 + 0.05 # Żerań Wschodni

#Filters and sorts trams and saves to ($filename)-filtered.json
filter_trams <- function(filename, day_of_month) 
{
  trams <- fromJSON(filename)$results %>%
    filter(Lon >= TRAMS_WEST, Lat <= TRAMS_NORTH) %>%
    filter(Lon <= TRAMS_EAST, Lat >= TRAMS_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    arrange(Time)
  
  output_name <- paste(substring(filename, 1, nchar(filename) - 5), "-filtered.json", sep="")
  write(toJSON(trams, pretty = TRUE), file = output_name)
}