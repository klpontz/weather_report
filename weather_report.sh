#! /bin/bash

## OJECTIVES OF SCRIPT
# 1. Download raw weather data
# 2. Extract data of interest from the raw data
# 3. Transform the data as required
# 4. Load the data into a log file using a tabular format
# 5. Schedule the entire process to run automatically at a set time daily

## Set the PATH explicitly
# To avoid issues when running as a cron job
export PATH=/usr/bin:/bin:/usr/local/bin:$PATH

## Set the variable to prepare to download via curl and get the date to add to the file name
city=casablanca
weather="wttr.in/$city"
today=$(date +%Y%m%d)

## Get the weather data and write it to a file
# Appending a date stamp to the file name ensures it's a unique name.
# This builds a history of the weather forecasts which you can revisit at any time to recover from errors or expand the scope of your reports
# Using the prescribed date format ensures that when you sort the files, they will be sorted chronologically. It also enables searching for the report for any given date.

weather_report="/Users/pontz/Projects/weather_report/logs/raw_data_$today"

# Go get the weather data

echo "$(date) - Starting download" >> "tmp/script_output.log"
curl "$weather" -o $weather_report

# If curl fails (exit status other than 0), the script can either retry the download or exit early.
if [ $? -ne 0 ]; then
	echo "$(date) - Failed to download weather data."  >> "tmp/script_output.log"
    exit 1
fi

# Handle missing file gracefully. Don't process if file is non-existent.
if [ ! -f "$weather_report" ]; then
	echo "$(date) - Weather report file not found." >> "tmp/script_output.log"
    exit 1
fi

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
