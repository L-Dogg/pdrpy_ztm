library(ggmap)
library(ggplot2)
library(jsonlite)
library(dplyr)
library(lubridate)

map <- get_map("Warszawa, Polska", zoom=12)

setwd(paste(getwd(), "/Semestr6/pdrpy_ztm/", sep=""))
filename = 'data/23-05/trams_lowfloor-filtered.json'

trams <- fromJSON(filename) %>%
  filter(hour(Time) %in% 6:23) %>%
  distinct() %>%
  arrange(Time)

normalBuses14 <- rbind(fromJSON('data\\14-05\\buses-normal-filtered.json'), fromJSON('data\\14-05\\buses2-normal-filtered.json'),
              fromJSON('data\\14-05\\buses3-normal-filtered.json'))

fastBuses14 <- rbind(fromJSON('data\\14-05\\buses-fast-filtered.json'),fromJSON('data\\14-05\\buses2-fast-filtered.json'),
                     fromJSON('data\\14-05\\buses3-fast-filtered.json'))

fastBuses15 <- fromJSON('data\\15-05\\buses3-fast-filtered.json')
fastPeriodicBuses15 <- fromJSON('data\\15-05\\buses3-fast-periodic-filtered.json')
zoneBuses15 <- fromJSON('data\\15-05\\buses3-zone-filtered.json')
normalBuses15 <- fromJSON('data\\15-05\\buses3-normal-filtered.json')

nightBuses14 <- rbind(fromJSON('data\\14-05\\buses-night-filtered.json'), 
                      fromJSON('data\\14-05\\buses2-night-filtered.json'))

trams23 = fromJSON('data\\2016-03-23\\20160323_tramwaj-filtered.json') %>%
  distinct() %>%
  arrange(Time)


# Normal plot
normalPlot <- function(df) {
  ggmap(map, extent = "device") + geom_point(aes(x = Lon, y = Lat), colour = df$Lines,
                                                 alpha = 0.1, size = 1, data = df)
}

normalPlot(normalBuses14)
normalPlot(fastBuses14)
normalPlot(fastBuses15)
normalPlot(fastPeriodicBuses15)
normalPlot(zoneBuses15)
normalPlot(normalBuses15)


# Heat map
heatmap <- function (df, title) { 
  ggmap(map, extent = "device") + geom_density2d(data = df, 
  aes(x = Lon, y = Lat), size = 0.3) + stat_density2d(data = df, 
  aes(x = Lon, y = Lat, fill = ..level.., alpha = ..level..), size = 0.01, 
  bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE) +
  ggtitle(title)
}

heatmap(nightBuses14)
heatmap(normalBuses14)
heatmap(trams23, '')

