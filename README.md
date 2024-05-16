Hi there, thanks for taking a gander at this shell scipt. This is the first shell script that I've ever created. It was part of the final project in a course I took called, [Hands-on Introduction to Linux Commands and Shell Scripting](https://www.coursera.org/learn/hands-on-introduction-to-linux-commands-and-shell-scripting).

## GOAL OF SCRIPT                              
  1. Download raw weather data
  2. Extract data of interest from the raw data
  3. Transform the data
  4. Load the data into a log file using a tabular format
  5. Schedule the entire process to run automatically at a set time daily

## Cron Job
To schedule a cron job that runs the script automatically at a specific time use the following code. And in case you forgot, open your cron file using the command `crontrab -e`.

```
PATH=/usr/bin:/bin:/usr/local/bin                                            0 12 * * * /Directory/path/to/the/script/weather_report.sh >> /tmp/cron_output.log 2>&1
``` 
As written, this will run the script every day at 12:00PM.

