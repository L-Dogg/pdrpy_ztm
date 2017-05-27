library(jsonlite)
library(dplyr)
library(lubridate)


filename = 'data/23-05/trams_lowfloor-filtered.json'

trams <- fromJSON(filename) %>%
  filter(Hour %in% 6:23) %>%
  distinct() %>%
  arrange(Hour)

counts <- rep(0, 6)
lowfloors <- rep(0, 6)
for (i in 1:6)
{
  counts[i] <- nrow(trams %>%
    filter(Hour == i + 6) %>%
    group_by(FirstLine, Brigade) %>%
    summarise(count = n()))
  
  lowfloors[i] <- nrow(trams %>%
   filter(Hour == i + 6, LowFloor == TRUE) %>%
   group_by(FirstLine, Brigade) %>%
   summarise(count = n()))
}

directory = 'data/23-05/'
df <- matrix(c(lowfloors, counts), ncol = 2)
colnames(df) <- c('Lowfloor', 'All')
write.csv(df, paste(directory, "tram-counts.csv", sep=""), na='', row.names = FALSE)

##############################

filename = 'data/15-05/trams3-filtered.json'
trams <- fromJSON(filename) %>%
  filter(hour(Time) %in% 0:23) %>%
  distinct() %>%
  arrange(hour(Time))

counts <- rep(0, 24)
for (i in 0:23)
{
  counts[i+1] <- nrow(trams %>%
    filter(hour(Time) == i) %>%
    group_by(Lines, Brigade) %>%
    summarise(count = n()))
}

directory = 'data/15-05/'
df <- matrix(c(0:23, counts), ncol = 2)
colnames(df) <- c('Hour', 'Count')
write.csv(df, paste(directory, "tram-counts.csv", sep=""), na='', row.names = FALSE)