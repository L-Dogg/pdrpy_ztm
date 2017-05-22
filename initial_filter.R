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
filter_trams <- function(filename, day_of_month, month) 
{
  trams <- fromJSON(filename)$results %>%
    filter(Lon >= TRAMS_WEST, Lat <= TRAMS_NORTH) %>%
    filter(Lon <= TRAMS_EAST, Lat >= TRAMS_SOUTH) %>%
    filter(day(Time) >= day_of_month) %>%
    filter(month(Time) >= month) %>%
    arrange(Time)
  
  output_name <- paste(substring(filename, 1, nchar(filename) - 5), "-filtered.json", sep="")
  write(toJSON(trams, pretty = TRUE), file = output_name)
}

BUSES_SOUTH <- 52.080793 # Piaseczno
BUSES_NORTH <- 52.408296 # Legionowo
BUSES_WEST <- 20.833262 # Piastów
BUSES_EAST <- 21.354953 # Halinów

NormalBusLines <- c("102", "103", "104", "105", "107", "108", "109", "110", "111", "112", "114", "115", "116",
                  "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129",
                  "131", "132", "133", "134", "135", "136", "138", "139", "140", "141", "142", "143", "145",
                  "146", "147", "148", "149", "151", "152", "153", "154", "155", "156", "157", "158", "159",
                  "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172",
                  "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185",
                  "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198",
                  "199", "201", "202", "203", "204", "205", "206", "207", "208", "209", "211", "212", "213",
                  "214", "217", "218", "219", "221", "222", "225", "227", "240", "245", "256", "262")

NormalPeriodicBusLines <- c("300", "303", "304", "305", "306", "311", "314", "317", "318", "320", "323",
                          "326", "331", "332", "334", "338", "340", "345", "365", "379", "385", "397")

FastPeriodicBusLines <- c("401", "402", "409", "411", "412", "414")

FastBusLines <- c("500", "501", "502", "503", "504", "507", "509", "511", "512", "514",
                 "516", "517", "518", "519", "520", "521", "522", "523", "525", "527")

ZoneBusLines <- c("700", "701", "702", "703", "704", "705", "706", "707", "708", "709", "710", "711", "712",
                "713", "714", "715", "716", "717", "719", "720", "721", "722", "723", "724", "725", "727",
                "728", "729", "730", "731", "733", "734", "735", "736", "737", "738", "739", "741", "742", "743")

ZoneSupplementaryBusLines <- c("L-1", "L-2", "L-3", "L-4", "L-5", "L-6", "L-7", "L-8", "L-9", "L10", "L11", "L12", "L13",
                          "L14", "L15", "L16", "L17", "L18", "L19", "L20", "L21", "L22", "L23", "L24", "L25", "L26",
                          "L27", "L28", "L29", "L30", "L31", "L32", "L35", "L36", "L37", "L38", "L39", "L40")

ZonePeriodicBusLines <- c("800")

SpecialBusLines <- c("900")

ExpressBusLines <- c("E-1", "E-2", "E-7", "E-9")

NightBusLines <- c("N01", "N02", "N03", "N11", "N12", "N13", "N14", "N16", "N21", "N22", "N24", "N25", "N31", "N32",
                 "N33", "N34", "N35", "N36", "N37", "N38", "N41", "N42", "N43", "N44", "N45", "N46", "N50", "N52",
                 "N56", "N58", "N61", "N62", "N63", "N64", "N66", "N71", "N72", "N81", "N83", "N85", "N88", "N91", "N95")


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
