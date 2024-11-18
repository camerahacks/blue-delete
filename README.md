# Blue Delete

An effective way to delete all your Tweets.

If this script was useful to you and you would like to support my work, you can buy me a coffee through the link below.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J6BINRX)

**Please proceed with caution.** There is no going back after you delete your Tweets. Do it at your own risk!

## Download your Twitter/X Archive

The first thing you should do is request your Twitter/X archive. Blue Delete uses the archive files to know which Tweets to delete. It usually takes 24 hours for Twitter/X to get your archive ready.

So, request your archive and work on the other steps below while you wait for your archive to be ready.

You can so by going to ```Settings and privacy > Your account > Download and archive of your data``` either through the X app or the website.

## Step by Step Instructions

Here's how I used my Raspberry Pi to delete all my Tweets.

This script does not require access to the Twitter official API to delete your tweets. Instead, it communicates with Twitter the same way that browser app communicates with TWitter servers.

### Tweet Archive

Unzip the tweet archive and copy the ```tweets.js``` file to the same folder where you placed this python script. ```tweets.js``` contains the information to all your tweets.

### Browser Session Information

Login to your Twitter/X account through a web browser on a desktop computer. The instructions below are for Chromium but they should be the same in all browsers.

Open your browser developer tools by pressing ```Ctrl + Shift + I``` on the keyboard and go to the ```Network``` tab. This is where you can see all the traffic between your browser (your computer)
and the network operations it is performing.

Still on your Twitter/X page, go to your profile page and choose a single Tweet to delete. Make sure that network traffic is being recorded. The ```record``` button should be red.

![Record button in developer tools](./media/Record%20Network%20Traffic.png "Record Network Traffic")

Delete the Tweet and press the red ```record``` button to stop recording network traffic.

Find the entry for 