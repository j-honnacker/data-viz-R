library(data.table)
library(fasttime)   # converting char => datetime
library(magrittr)
library(ggplot2)

# set working directory
'setwd("/Users/jhonnacker/data-viz-R")'


# read data
rhine_wl_dt <- fread( file = "data_stg1/rhine_wl_1996-2018.csv" )

# "data.table v1.12.8" documentation suggests `fasttime` for converting
rhine_wl_dt[,date := fasttime::fastPOSIXct(date)]


# LINE CHART ----
rhine_wl_dt %>%
  ggplot( aes(x=date, y=water_level) ) +
    geom_line(na.rm=TRUE)
