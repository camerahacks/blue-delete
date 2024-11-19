# Blue Delete

An effective way to delete all your Tweets.

If this script was useful to you and you would like to support my work, you can buy me a coffee through the link below.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J6BINRX)

**Please proceed with caution.** There is no going back after you delete your Tweets. Do it at your own risk!

## Step by Step Instructions

Here's how I used my Raspberry Pi to delete all my Tweets. You don't need a Raspberry Pi, though. This is just a Python script.

This script does not require access to the Twitter official API to delete your tweets. Instead, it communicates with Twitter the same way that browser app communicates with TWitter servers.

## Download your Twitter/X Archive

The first thing you should do is request your Twitter/X archive. Blue Delete uses the archive files to know which Tweets to delete. It usually takes 24 hours for Twitter/X to get your archive ready.

So, request your archive and work on the other steps below while you wait for your archive to be ready.

You can so by going to ```Settings and privacy > Your account > Download and archive of your data``` either through the X app or the website.

Once the archive is ready for download, unzip the tweet archive and copy the ```tweets.js``` file to the same folder where you placed this python script. ```tweets.js``` contains the information to all your tweets.

## Browser Session Information

Login to your Twitter/X account through a web browser on a desktop computer. The instructions below are for Chromium but they should be the same in all browsers.

Open your browser developer tools by pressing ```Ctrl + Shift + I``` on the keyboard and go to the ```Network``` tab. This is where you can see all the traffic between your browser (your computer)
and the network operations it is performing.

Still on your Twitter/X page, go to your profile page and choose a single Tweet to delete. Make sure that network traffic is being recorded. The ```record``` button should be red.

<img src="./media/Record Network Traffic.png" alt="Record button in developer tools" width="600"/>

Delete the Tweet and press the red ```record``` button to stop recording network traffic.

Find the entry labeled ```DeleteTweet```. Right-click on this entry and choose ```Copy > Copy as cURL (bash)```. This will put the cURL command in your clipboard.

<img src="./media/Record Network Traffic - DeleteTweet.png" alt="Delete Tweet Action in developer tools" width="600"/>

Open the file names ```curl.txt``` and replace all the content of the file with the cURL command from the step above. This will be used to extract all your session and cookie information.

Browser reverse engineering is fun, huh?

## Run The script

Time to run the script and delete all your Tweets. **Proceed with caution, there is no going back.**

The script will read all your tweets from the archive, and will make API calls to delete each one of them. It keeps track of tweets that have been deleted in a file called ```tracking.json```.
If the process is interrupted for some reason, it doesn't have to start from the beginning again.