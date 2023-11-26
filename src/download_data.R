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
library(readxl)
library(janitor)

# -------------------------------------------
# D O W N L O A D
# -------------------------------------------

# Read in NUMBAT 2022

# MON

data_mon <- read_csv("http://crowding.data.tfl.gov.uk/Crowding/LUTrainLoadingData.csv")


