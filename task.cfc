/**
 * Delete all your Tweets in one fell swoop.
 * 
 * Copyright (c) 2024 André Costa
 * 
 * @author André Costa @ dphacks.com
 * 
 * This is the main CFML Task Runner
 */

component {

    property name="progressBarGeneric" inject="progressBarGeneric";

    function run(){

        print.greenLine('Welcome to Blue  Delete! deleting tasks. This script requires the Twitter API keys and secrets. Make sure to check out the instructions at www.dphacks.com')
        print.line()

        // load the twitter API
        twitterAPI = new twitterEngine()

        // read the json file with all the tweets
        tweetArchive = fileRead( 'tweets.js' )

        // The tweets archive file is not valid json but if remove the object name from the .js file,
        // we can make it into a json file

        // find the position of the first opening [
        // Then replace the opening character sith an empty string
        jsonStart = find( '[', tweetArchive )
        leftPiece = left( tweetArchive, jsonStart-1 )
        tweetArchive = replace( tweetArchive, leftPiece, '' )

        // Load the json file as a cfml object
        tweetsObj = deserializeJSON( tweetArchive )

        // if the tracking file doesn't exist, load all the tweets into the tracking file.
        if ( !fileExists('tracking.json')) {

            // Loop over each tweet and create the tracking structure
            // They all start with a 'pending' status
            for ( tweet in tweetsObj ) {

                tracking[tweet.tweet.id] = 'pending'
                
            }

            fileWrite( 'tracking.json' ,serializeJSON( tracking ) )
        }
        // If it does exist, load everything into a cfml structure
        else {

            tracking = deserializeJSON( fileRead( 'tracking.json' ) )

        }

        // Get all of the pending deletes
        pendingDeletes = tracking.filter( function( key, value) {

            return (value == 'pending')

        })

        numberPendingDeletes = structCount(pendingDeletes)

        print.line( 'You have '&numberPendingDeletes&' Tweets to be deleted' ).toConsole()
        
        calculateTime = numberPendingDeletes/50*15/60

        print.line( 'This will take approximately '&round(calculateTime)&' hours' ).toConsole()
        print.line()

        print.redLine( 'Do you want to continue and *delete* all your Tweets?' )

        if( confirm( 'There is no going back [y/n]' ) ){

            print.greenLine('Let''s GOOOOOOO...').toConsole()
            print.line()
            // Draw initial progress bar
            progressBarGeneric.update( percent=0 );

        }else {

            print.redLine('See you soon...')

            break;
        }

        // The API free tier limits 50 delete calls per 15 minutes
        // So, only delete 50 tweets at a time

        // currentCount will keep track of how many tweets have been deleted.
        currentCount = 0

        // Count will keep track of how many API calls have been made.
        count = 0

        // count fails so the script stops after a number of fails
        countFail = 0
        
        try {
            
            deleting = 1
            
            while ( deleting ) {

                for ( key in pendingDeletes ) {

                    deleteTweet = twitterAPI.deleteTweet(key)

                    count = count + 1

                    if ( deleteTweet.status_code==200 ) {
                        
                        tracking[key] = 'deleted'

                        currentCount = currentCount + 1

                    } else if ( deleteTweet.status_code==429 ) {

                        // Too many attempts, wait 15 minutes
                        progressBarGeneric.clear()

                        print.redLine('Too many requests, waiting 15 minutes...').toConsole()
                        
                        sleep(901000)
                        
                    } else {
                        
                        print.redLine(deleteTweet.text).toConsole()

                        countFail = countFail + 1

                        if( countFail GTE 5 ){

                            progressBarGeneric.clear()

                            print.redLine('Too many failed attemps, please check dphacks.com for more information')

                            abort;

                        }
                    }

                    progressBarGeneric.update( percent=round(currentCount/numberPendingDeletes*100), currentCount=currentCount, totalCount=numberPendingDeletes );
        
                    if( count == 50 ){

                        count = 0
        
                        fileWrite( 'tracking.json', serializeJSON( tracking ))

                        progressBarGeneric.clear()
                        
                        progressBarGeneric.update( percent=round(currentCount/numberPendingDeletes*100), currentCount=currentCount, totalCount=numberPendingDeletes );
                        
                        // Do not change this sleep. This is to make sure you are not hitting the API rate limit
                        sleep(901000)
                    }

                    sleep(200)
                    
                }
                
            }
            
        } catch ( java.lang.InterruptedException e ) {
            
            progressBarGeneric.clear()
            print.redLine('Interrupted!')
            
        } finally{

            fileWrite( 'tracking.json', serializeJSON( tracking ))
            print.greenLine( 'Progress Saved!' )

        }
    }

}