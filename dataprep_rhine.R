
library(tidyr)
library(data.table)

# set working directory
'setwd("/Users/jhonnacker/data-viz-R")'

# set language for as.Date function
Sys.setlocale("LC_TIME", "de_DE")

# prepare list which will contain the DataFrames
list_of_rhine_wl_dfs <- list()

# main loop to read files into DataFrames
for( year in 1996:2018 ) {

  # read file into DataFrame 'rhine_wl_df'
  if (year < 2018) {
    file <- paste0("data_src/Rhine-water-levels/Rheinpegel_Tag ", year,".csv")
  }
  else {
    file <- paste0("data_src/Rhine-water-levels/Rheinpegel_Tag", year,".csv")
  }
  rhine_wl_df <- readr::read_delim( file = file
                                  , delim = ";"
                                  )
  
  # collapse "month" columns into key-value pairs ('month' - 'water_level")
  rhine_wl_df <- gather(rhine_wl_df, "month", "water_level", -Tag)
  
  # calculate 'date'
  rhine_wl_df$date <- as.Date(paste(rhine_wl_df$Tag, rhine_wl_df$month, year), format="%d %B %Y")
  
  # - select only 'date' and 'water_level' column
  # - drop rows without a real date (e.g., where day was "31" and month was "April")
  rhine_wl_df <- rhine_wl_df %>%
    dplyr::select(date, water_level) %>%
    dplyr::filter(!is.na(date))

  # add DataFrame to list
  list_of_rhine_wl_dfs = c(list_of_rhine_wl_dfs, list(rhine_wl_df))
}

# create final DataFrame 'rhine_wl'
rhine_wl <- do.call("rbind", list_of_rhine_wl_dfs)

# save final DataFrame 'rhine_wl'
fwrite(rhine_wl, file = "data/rhine_wl_1996-2018.csv")
