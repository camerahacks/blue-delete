import re
import requests
import json
import os.path
import time
import sys
import random

#####
# Helper Methods
#####

def filter_pending(item):
     key, value = item
     return value == 'pending'

# Save tracking file
def save_tracking(tracking_info):
    with open('tracking.json', 'w') as tracking_file:
         json.dump(tracking_info, tracking_file)

headers = {}
tracking = {}

endpoint = "https://twitter.com/i/api/graphql/VaenaVgh5q5ih7kvyVjgtg/DeleteTweet"

#####
# Meat and Potatoes
#####

def main():
    global tracking
    # Get the header values from the example curl command
    with open('curl.txt') as curlfile:
        
        while line := curlfile.readline():
            
            if("-H" in line):
                
                matches = re.findall(r"'(.*?)'", line)

                for match in matches:

                    splitter = match.find(":")

                    key = match[:splitter]
                    value = match[splitter+1:].strip()

                    # Add the key and value to the header dict to be used with the request
                    headers[key]=value

    # Open the tweet archive file
    with open('tweets.js', encoding='utf8') as tweetfile:
            
            # Find the position of the first opening [
            # Then replace the opening character with an empty string
            file_content = tweetfile.read()
            json_start = file_content.find("[")
            tweet_archive = file_content[json_start:]
            archive_json = json.loads(tweet_archive)

            # print(archive_json)

    # Open the tracking file if one exists
    if(os.path.exists('tracking.json')):
        
        with open('tracking.json') as tracking_file:
        
            tracking = json.load(tracking_file)

    else:

        # Create a tracking dict 
        for tweets in archive_json:
            tracking[tweets['tweet']['id']] = 'pending'

        # Save tracking file
        save_tracking(tracking)

    pending_deletes = dict(filter(filter_pending, tracking.items()))

    delete_count = len(pending_deletes.keys())

    print("You have "+str(delete_count)+" Tweets to delete.")

    time_to_delete = round(delete_count/100*15/60, 2)

    print("This will take approximately "+str(time_to_delete)+" hours.")


    # Delete the tweets
    current_count = 0
    count_fail = 0
    count = 0

    for key, value in pending_deletes.items():

        tweetId = key

        body = {"variables":{"tweet_id":tweetId,"dark_request":False},"queryId":"VaenaVgh5q5ih7kvyVjgtg"}

        response = requests.post(url=endpoint, headers=headers, json=body)

        count = count + 1

        if(response.status_code == 200):

            tracking[key] = 'deleted'

            print("Tweet "+key+" deleted!")

            current_count = current_count + 1

            # Wait anywhere from 1 second to 2 seconds between requests
            time.sleep(random.randint(1, 2))
        
        elif(response.status_code == 429):

            # Too many attempts, wait 15 minutes
            print("Too many attempts. Waiting 15 minutes...")
            time.sleep(901)

        else:

            count_fail = count_fail + 1

            if(count_fail > 5):

                print('Too many failed attempts. Aborting. Progress saved.')

                save_tracking(tracking)

                sys.exit()
        
        # Wait 5 minutes after 101 requests
        if(count > 100):

            count = 0

            print("Taking a break. Deleting Tweets will resume shortly")

            deletes_left = delete_count-current_count
            print(str(current_count)+" Tweets deleted. "+str(deletes_left)+" left.")

            save_tracking(tracking)

            time_update = round(deletes_left/100*15/60, 2)

            print("Approximately "+str(time_update)+" more hours to go...")

            time.sleep(300)

# Let's GOOOOOO!
try:
    if input("Are you sure you want to delete all your Tweets? There is no going back. [y/n]") != "y":
        sys.exit()
    
    main()

except KeyboardInterrupt:
    
    save_tracking(tracking)
    
    print("Script Interrupted. Progress saved.")
    sys.exit()