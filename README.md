# Blue Delete

An effective way to delete all your Tweets.

If this script was useful to you and you would like to support my work, you can buy me a coffee through the link below.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J6BINRX)

## Download your Twitter/X Archive

The first thing you should do is request your Twitter/X archive. Blue Delete uses the archive files to know which Tweets to delete. It usually takes 24 hours for Twitter/X to get your archive ready.

So, request your archive and work on the other steps below while you wait for your archive to be ready.

You can so by going to ```Settings and privacy > Your account > Download and archive of your data``` either through the X app or the website.

## Step by Step Instructions

Here's how I used my Raspberry Pi to delete all my Tweets.

This script requires access to the Twitter API to delete your tweets. You can sign up for the free version through [Twitter's developer portal](https://developer.x.com)

You will also need to install [CommandBox](https://commandbox.ortusbooks.com/setup/installation) to your Raspberry Pi (or any other Linux computer). CommandBox allows you to run a server or a task based on the powerful CFML web scripting language. This script does not require to run a server locally.

### Install CommandBox
CommandBox is a standalone tool that lets you run a CFML web server or a script (called tasks) using the powerful CFML web scripting language. The Blue Delete script does not require a web server but it does require a CFML interpreter.

You can visit [CommandBox's](https://commandbox.ortusbooks.com/setup/installation) website for more information. But I have all the steps needed to install CommandBox on a Raspberry Pi listed below.

CommandBox runs on Mac, Windows, and Linux.

Install Dependencies:

```bash
sudo apt install libappindicator-dev
```

Add the package repo:
```bash
curl -fsSl https://downloads.ortussolutions.com/debs/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/ortussolutions.gpg > /dev/null
```
```bash
echo "deb [signed-by=/usr/share/keyrings/ortussolutions.gpg] https://downloads.ortussolutions.com/debs/noarch /" | sudo tee /etc/apt/sources.list.d/commandbox.list
```
Update the package list:
```nash
sudo apt update
```
```bash
sudo apt install openjdk-11-jdk
```
```bash
sudo apt install apt-transport-https commandbox
```

### Sign up for a developer account

Sign in to your Twitter account on a browser and go to the [Twitter/X developer's portal](https://developer.x.com)

Go to the Projects & Apps tab. If there isn't a default project created already for you, create one.

This script uses the OAuth 1.0 method of athentication. 

Next, Setup user authentication and make sure to select Read and write

Go to the Keys and tokes tab. This is where you will generate the access keys needed to delete your tweets. You will only be able to delete your own Tweets.
These keys and tokes will go in the ```Application.cfc``` file. Be ready to copy this information and save it in a safe location. Do not share this information with anyone else as anyone with access to these keys and tokens can control your account. If you don't copy this information you will have to regenerate them again.

Copy the API Key and the API Secret

Generate a Bearer Token

Generate Access Token and Secret