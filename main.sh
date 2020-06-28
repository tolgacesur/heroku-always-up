#!/bin/sh

# Key of heroku-always-up related environment variables
HEROKU_APP_ENV_KEY="HEROKU_APP_URL"

# Delay between each request loop
HEROKU_SLEEP_TIME_IN_SECONDS=20*60

# Stops this process in this time interval
HEROKU_SLEEP_START="02:00"
HEROKU_SLEEP_END="08:00"

# Main loop
while true; do 
    currenttime=$(date +%H:%M);

    if [[ "$currenttime" < "$HEROKU_SLEEP_START" ]] || [[ "$currenttime" > "$HEROKU_SLEEP_END" ]]; then
        # Get your application url
        app_url=""
        env | while read line; do
            if [[ $line == *$HEROKU_APP_ENV_KEY* ]]; then
                app_url=${line#*=};

                # Send request to your application
                echo "$currenttime Sending requests...";
                curl "$app_url"
                break
            fi
        done
    fi

    # Send request to this app
    curl -s -o /dev/null "http://0.0.0.0"

    echo "Job is done!";

    # sleep and repeat
    sleep ${HEROKU_SLEEP_TIME_IN_SECONDS}
done