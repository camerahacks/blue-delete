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

        print.line('Welcome to the Tweet deleting tasks. This script requires the Twitter API keys and secrets. Make sure to check out the instructions at www.dphacks.com')
        print.line()

        // load the twitter API
        tweeterAPI = new twitterEngine()

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

        print.line( 'Do you want to continue and *delete* all your Tweets?' )

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
        currentCount = 0
        count = 0
        
        try {
            
            deleting = 1
            
            while ( deleting ) {

                for ( key in pendingDeletes ) {

                    tracking[key] = 'deleted'
                    
                    count = count + 1

                    currentCount = currentCount + 1

                    // print.greenLine( 'Deleted Tweet: '&key ).toConsole()

                    progressBarGeneric.update( percent=round(currentCount/numberPendingDeletes*100), currentCount=currentCount, totalCount=numberPendingDeletes );
        
                    if( count == 50 ){

                        count = 0
        
                        fileWrite( 'tracking.json', serializeJSON( tracking ))

                        progressBarGeneric.clear()
                        sleep(500)
                        progressBarGeneric.update( percent=round(currentCount/numberPendingDeletes*100), currentCount=currentCount, totalCount=numberPendingDeletes );
        
                        sleep(1000)
                    }

                    sleep(500)
                    
                }
                
            }
            
        } catch ( java.lang.InterruptedException e ) {

            print.redLine('Interrupted!')
            
        } finally{

            fileWrite( 'tracking.json', serializeJSON( tracking ))
            print.greenLine( 'Progress Saved!' )

        }
    }

    function loadFiles(){

    }
}