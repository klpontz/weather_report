#! /bin/bash

# Set the PATH explicitly to avoid issues when running as a cron job
export PATH=/usr/bin:/bin:/usr/local/bin:$PATH

# Ensure script runs in the correct directory as cron
cd /Users/pontz/Projects/weather_report

# Set the variables for downloading via curl and for the date-stamped file name
CITY=casablanca
WEATHER="wttr.in/$CITY"
TODAY=$(date +%Y%m%d)
WEATHER_REPORT="logs/raw_data_$TODAY"
LOG_FILE="tmp/script_output.log"
TEMP_FILE="logs/temperature.txt"
LOCATION="Morocco/Casablanca"

# Function to log messages with timestamps
log_message() {
    echo "$(date) - $1" >> "$LOG_FILE"
}

# Go get the weather data

echo "$(date) - Starting download" >> "tmp/script_output.log"
curl "$WEATHER" -o $WEATHER_REPORT

# If curl fails (exit status other than 0), the script can either retry the download or exit early.
if [ $? -ne 0 ]; then
	echo "$(date) - Failed to download weather data."  >> "tmp/script_output.log"
    exit 1
fi

# Handle missing file gracefully. Don't process if file is non-existent.
if [ ! -f "$WEATHER_REPORT" ]; then
	echo "$(date) - Weather report file not found." >> "tmp/script_output.log"
    exit 1
fi

## Extract the required data from the raw data
# Grabs the temperature data from the weather report and stores it in a file

todays_temp="logs/temperature.txt"

grep "°F" $WEATHER_REPORT > $todays_temp

# Extract the current temperature
obs_tmp=$(head -1 $todays_temp | tr -s " " | xargs | rev | cut -d " " -f2 | rev)

# Extract the forecasted temperature for tomorrow at noon
fc_tmp=$(head -3 $todays_temp | tail -1 | tr -s " " | xargs | cut -d "F" -f2 | rev | cut -d " " -f2 | rev)

## Store the current hour, day, month, and year in corresponding shell variables for our target location
# -u sets the timezone to UTC
hour=$(TZ="$LOCATION" date -u +%H) 
day=$(TZ="$LOCATION" date -u +%d)
month=$(TZ="$LOCATION" date +%m)
year=$(TZ="$LOCATION" date +%Y)

echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp" >> rx_poc.log
