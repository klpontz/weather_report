#! /bin/bash

## OJECTIVES OF SCRIPT
# Download raw weather data
# Extract data of interest from the raw data
# Transform the data as required
# Load the data into a log file using a tabular format
# Schedule the entire process to run automatically at a set time daily


## Set the variable to prepare to download via curl and get the date to add to the file name
city=casablanca
weather="wttr.in/$city"
today=$(date +%Y%m%d)
weather_report="/Users/pontz/Projects/weather_report/logs/raw_data_$today"

## Get the weather data and write it to a file
# Appending a date stamp to the file name ensures it's a unique name.
# This builds a history of the weather forecasts which you can revisit at any time to recover from errors or expand the scope of your reports
# Using the prescribed date format ensures that when you sort the files, they will be sorted chronologically. It also enables searching for the report for any given date.

curl "$weather" -o $weather_report

## Extract the required data from the raw data
# Grabs the temperature data from the weather report and stores it in a file

todays_temp="/Users/pontz/Projects/weather_report/logs/temperature.txt"

grep "°F" $weather_report > $todays_temp

# Extract the current temperature
obs_tmp=$(head -1 $todays_temp | tr -s " " | xargs | rev | cut -d " " -f2 | rev)

# Extract the forecasted temperature for tomorrow at noon
fc_tmp=$(head -3 $todays_temp | tail -1 | tr -s " " | xargs | cut -d "F" -f2 | rev | cut -d " " -f2 | rev)

## Store the current hour, day, month, and year in corresponding shell variables for our target location
# -u sets the timezone to UTC
hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp" >> rx_poc.log
