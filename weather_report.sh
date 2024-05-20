#! /bin/bash

# Set the PATH explicitly to avoid issues when running as a cron job
export PATH=/usr/bin:/bin:/usr/local/bin:$PATH

# Ensure script runs in the correct directory as cron
cd /Users/pontz/Projects/weather_report

# Set the variables for downloading via curl and for the date-stamped file name
CITY=casablanca
WEATHER="wttr.in/$CITY"
TODAY=$(date +%Y%m%d)
TODAYS_WEATHER_REPORT="logs/raw_data_$TODAY"
LOG_FILE="tmp/script_output.log"
TEMP_FILE="logs/temperature.txt"
LOCATION="Morocco/Casablanca"

# Function to log messages with timestamps
log_message() {
    echo "$(date) - $1" >> "$LOG_FILE"
}

# Function to download weather data
download_weather_data () {
    log_message "Starting download"
    curl "$WEATHER" -o "$TODAYS_WEATHER_REPORT"
    if [ $? -ne 0 ]; then
	    log_message "Failed to download weather data."
        exit 1
    fi
}

# Function to extract temperature data
extract_temperature_data () {
    log_message "Starting to extract temperature data."
    grep "°F" "$TODAYS_WEATHER_REPORT" > "$TEMP_FILE"
}

# Function to extract specific temperature from file
extract_specific_temperatures () {
    obs_tmp=$(head -1 "$TEMP_FILE" | tr -s " " | xargs | rev | cut -d " " -f2 | rev)
    fc_tmp=$(head -3 "$TEMP_FILE" | tail -1 | tr -s " " | xargs | cut -d "F" -f2 | rev | cut -d " " -f2 | rev)
}

# Function to get current time components in UTC
get_time_components () {
    hour=$(TZ="$LOCATION" date -u +%H) 
    day=$(TZ="$LOCATION" date -u +%d)
    month=$(TZ="$LOCATION" date +%m)
    year=$(TZ="$LOCATION" date +%Y)
}
# Main script execution
download_weather_data

# Handle missing file gracefully. Don't process if file is non-existent.
if [ ! -f "$TODAYS_WEATHER_REPORT" ]; then
	log_message "Weather report file not found."
    exit 1
fi

# Call functions
extract_temperature_data
extract_specific_temperatures
get_time_components

echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp" >> rx_poc.log