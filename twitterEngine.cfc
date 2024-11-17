/**
 * Delete all your Tweets in one fell swoop.
 * 
 * Copyright (c) 2024 André Costa
 * 
 * @author André Costa @ dphacks.com
 * 
 * Handles Titter API to delete tweets
 */

component hint="Twitter Calls" displayname="Twitter Calls" output="false" {

    public function init(){

        application.twitter_apiKey='< ENTER API KEY HERE >'
		application.twitter_apiKeySecret='< ENTER API SECRET HERE >'
		application.twitter_bearer='< ENTER BEARER TOKEN HERE >'
		application.twitter_access_token='< ENTER ACCESS TOKEN HERE >'
		application.twitter_access_token_secret='< ENTER ACCESS SECRET HERE >'

		return this;
	}

    
    public any function deleteTweet(required tweetId) localmode='modern' {
    
        endpoint = 'https://api.twitter.com/2/tweets/'&arguments.tweetId

        httpMethod = 'DELETE'

        oAuthAPI = new oauth()

        sendTweet = oAuthAPI.oAuth(httpMethod, '1.0', endpoint)

        return sendTweet

    }

}