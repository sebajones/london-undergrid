# -------------------------------------------
# R script for reading and processing Transport for London (TFL) NUMBAT
# Entry/Exit statistics for all stations in 2022
# Author: Seb Jones
# -------------------------------------------

# -------------------------------------------
# L I B R A R I E S
# -------------------------------------------

# Required libraries.
library(tidyverse)
library(sf)

# -------------------------------------------
# D O W N L O A D
# -------------------------------------------

# Read in NUMBAT 2022

# MON

data_mon <- read_csv("http://crowding.data.tfl.gov.uk/Crowding/LUTrainLoadingData.csv")

if(!dir.exists("./data")) {dir.create("./data")}

# -------------------------------------------

# Read in location data for stations

url <- "https://api.tfl.gov.uk/stationdata/tfl-stationdata-detailed.zip"
download.file(url, "./data/stations.zip")
unzip("./data/stations.zip", exdir="./data/stations")



# Only one set of coordinates per station needs to be kept, so we take the mean 
# position of all entrances.
locations <- read_csv("./data/stations/StationPoints.csv") %>%
  select(stn_code=StationUniqueId, lat=Lat, lon=Lon) %>%
  group_by(stn_code) %>%
  summarise(lat = mean(lat), lon=mean(lon))

# The full station names are in a separate file.
names <- read_csv("./data/stations/Stations.csv") %>%
  select(stn_code=UniqueId, stn_name=Name, zone=FareZones)
stations <- names %>% inner_join(locations, by = join_by(stn_code))

# The TFL API directory contains unnecessary data files.
unlink("./data/stations", recursive=TRUE)
unlink("./data/stations.zip", recursive=TRUE)

# Clean workspace.
rm(url, locations, names)

# The dataset contains stations outside the TFL network.
stations <- stations %>%
  filter(zone != "Outside")

# Convert the dataframe to simple features.
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
stations <- st_as_sf(stations, coords=c("lon","lat"), crs=projcrs) %>%
  st_transform(crs = 27700)

st_write(stations, append = FALSE, "./data/tfl_stations.geojson")

# Clean workspace
rm(stations, projcrs)