library(readr)
library(magrittr)
library(ggplot2)

# set working directory
'setwd("/Users/jhonnacker/data-viz-R")'


# read data
rhine_wl_df <- read_csv( file = "data_stg1/rhine_wl_1996-2018.csv" )


# LINE CHART ----
rhine_wl_df %>%
  ggplot( aes(x=date, y=water_level) ) +
    geom_line(na.rm=TRUE)
