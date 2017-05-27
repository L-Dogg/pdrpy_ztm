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


###########################
lines <- c(1, 2, 3, 4, 6, 7, 9, 10, 11, 13, 
           14, 15, 17, 18, 20, 22, 23, 24, 
           25, 26, 27, 28, 31, 33, 35, 44, 77)

filename = 'data/23-05/trams_lowfloor-filtered.json'
trams <- fromJSON(filename) %>%
  filter(hour(Time) %in% 0:23) %>%
  distinct() %>%
  arrange(hour(Time))

counts <- rep(0, length(lines))
lowfloors <- rep(0, length(lines))

k = 1

for (i in lines)
{
  counts[k] <- nrow(trams %>%
    filter(trimws(FirstLine) == i) %>%
    group_by(FirstLine, Brigade) %>%
    summarise(count = n()))
  
  lowfloors[k] <- nrow(trams %>%
   filter(trimws(FirstLine) == i, LowFloor == TRUE) %>%
   group_by(FirstLine, Brigade) %>%
   summarise(count = n()))
  k = k + 1
}

directory = 'data/23-05/'
df <- matrix(c(lines, lowfloors, counts), ncol = 3)
colnames(df) <- c('Line', 'Lowfloor', 'All')
write.csv(df, paste(directory, "tram-counts-by-line.csv", sep=""), na='', row.names = FALSE)
