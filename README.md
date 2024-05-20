Hi there, thanks for taking a gander at this shell scipt. This is the first shell script that I've ever created. It was part of the final project in a course I took called, [Hands-on Introduction to Linux Commands and Shell Scripting](https://www.coursera.org/learn/hands-on-introduction-to-linux-commands-and-shell-scripting).

## GOAL OF SCRIPT                              
  1. Download raw weather data
  2. Extract data of interest from the raw data
  3. Transform the data
  4. Load the data into a log file using a tabular format
  5. Schedule the entire process to run automatically at a set time daily

As you'll see in the output, the data that is stored in the tablular format is the year, month, day, hour, current temperature, and the forecasted temperature at 12:00PM for the following day.

## Cron Job
To schedule a cron job that runs the script automatically at a specific time use the following code. And in case you forgot, open your cron file using the command `crontrab -e`.

```
PATH=/usr/bin:/bin:/usr/local/bin
0 12 * * * /Directory/path/to/the/script/weather_report.sh >> /tmp/cron_output.log 2>&1
``` 
As written, this will run the script every day at 12:00PM.

The `PATH` is added to ensure that the job has access to all the commands in the script. I found that the script was failing without specifying these paths. These were the standard paths for my system. If you have changed the location of your bin, change these paths to match your system configuration.

## Update Path in Script
For the script to run, you will need to update this portion of the code at the beginnging of the script. Change the path so that the script changes directories into the directory where you've saved the directory with the script and other directories.

```
# Ensure script runs in the correct directory as cron 
cd /LOCATION/OF/DIRECTORY/weather_report
```

## Change the Location
The script is currently set up to pull weather data from Casablanca, Morroco. It's easy enough to change this. Simply, change these variables in the script to the location of your choice.

```
# Set the variables for downloading via curl and for the date-stamped file name
CITY=casablanca
LOCATION="Morocco/Casablanca"
```

Note: CITY is used in pulling the temperature data for a location and LOCATION is used for pulling the date components in UTC. 