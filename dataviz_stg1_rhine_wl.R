library(data.table)
library(fasttime)   # converting char => datetime
library(lubridate)  # floor_date()
library(scales)     # date_format() for x axis
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


# BAR CHART ----
# (1) pre-processing
rhine_wl_dt[complete.cases(rhine_wl_dt), # (1a) filter out missing values
            mean(water_level),           # (1b) compute mean of water levels...
            by=.(year = floor_date(date, unit="years")) # (1c) ..for each year
            ] %>%
  # (2) plotting
  ggplot(aes(x=year, y=V1), na.rm=TRUE) +
  geom_bar(stat = "identity") +
  scale_x_datetime(breaks="year", labels = date_format("%Y"), expand = c(0 ,0 )) +
  theme(axis.text.x=element_text( angle=90) )