library(jsonlite)
library(dplyr)
library(stringi)

setwd("H:\\PDRPy\\pd4\\pdrpy_ztm")


filenames = c('data\\14-05\\trams-filtered.json','data\\14-05\\trams2-filtered.json', 'data\\14-05\\trams3-filtered.json',
              'data\\15-05\\trams3-filtered.json', 'data\\14-05\\buses-initial-filtered.json', 
              'data\\14-05\\buses2-initial-filtered.json', 'data\\14-05\\buses3-initial-filtered.json', 
              'data\\15-05\\buses3-initial-filtered.json')

wrapper <- function(df) {
  df %>% as.data.frame %>% return
}


sapply(filenames, function(filename) 
{
  trams <- fromJSON(filename) %>%
    group_by(Brigade, Lines) %>%
    do(res = wrapper(.)) 

  base_dir <- substring(filename, 1, nchar(filename) - 5)
  dir.create(base_dir)

  lapply(1:nrow(trams), function (i) {
    if (!stri_detect_fixed(trams[i,2], "/")) {
    output_name <- paste(base_dir, '\\', trams[i,2], '-', trams[i,1], '.json', sep='')
    write(toJSON(trams[i,3], pretty = TRUE), file = output_name)
    }
  })
})

         