library(ggmap)
library(ggplot2)
library(jsonlite)
library(dplyr)
library(lubridate)

map <- get_map("Warszawa, Polska", zoom=11)

filename = '/home/orgiele/Semestr 6/pdrpy_ztm/data/15-05/trams3-filtered.json'

trams <- fromJSON(filename) %>%
  filter(hour(Time) %in% c(8, 9, 10)) %>%
  distinct() %>%
  arrange(Time)

# Normal plot
ggmap(map, extent = "device") + geom_point(aes(x = Lon, y = Lat), colour = "red", 
                                                 alpha = 0.1, size = 2, data = trams)

# Heat map
heatmap <- ggmap(map, extent = "device") + geom_density2d(data = trams, 
  aes(x = Lon, y = Lat), size = 0.3) + stat_density2d(data = trams, 
  aes(x = Lon, y = Lat, fill = ..level.., alpha = ..level..), size = 0.01, 
  bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE) +
  ggtitle("Tramwaje w poniedziałek 15.05.2017", subtitle = "godz. 8-10")

heatmap