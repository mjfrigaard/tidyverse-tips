#=====================================================================#
# File name: 01-import.R
# This is code to create: Importing video game data for goodenuff data project
# Authored by and feedback to: @mjfrigaard
# Last updated: 2020-09-01
# MIT License
# Version: 0.1
#=====================================================================#

# Packages ------------------------------------------------------------
library(tidyverse)
library(janitor)

# Import CSV file ------------------------------------------------------------
# source: https://www.kaggle.com/ashaheedq/video-games-sales-2019

# create a raw data folder
fs::dir_create("data/raw/")

# create a list of zipped files
zipped_files <- list.files("data/raw/", full.names = TRUE) 

# import the data into a data object
VideoGames <- map_df(.x = zipped_files, .f = read_csv)

# clean names 
VideoGames <- VideoGames %>% janitor::clean_names(case = "snake")