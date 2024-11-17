/**
 * Delete all your Tweets in one fell swoop.
 * 
 * Copyright (c) 2024 André Costa
 * 
 * @author André Costa @ dphacks.com
 * 
 * oAuth scheme and other helper functions
 */

component  hint="Handles oAuth authentication" displayname="oAuth API"  output="false" {

	public function init(){
		
		return this;
	}

    public function RFC3986(required string stringToEncode){
		encodedString = replacelist(urlencodedformat(arguments.stringToEncode),"%2D,%2E,%5F,%7E","-,.,_,~")
		
		return encodedString
	}

    public function getEpoch(date localDate){

		if(NOT isDefined('arguments.localDate')){
			localDate = now()
		}
		
    	return dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), localDate)
	}
	
	public string function hmacSha1(required string key, required string string) {
		secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec")
		mac = createObject("java", "javax.crypto.Mac")
		format = "ISO-8859-1"
		
		arguments.key = JavaCast("string", arguments.key).getBytes(format)
		arguments.string = JavaCast("string", arguments.string).getBytes(format)
		secretKeySpec = secretKeySpec.init(arguments.key,"HmacSHA1")
		mac = mac.getInstance(secretKeySpec.getAlgorithm())
		mac.init(secretKeySpec)
		mac.update(arguments.string)
		
		return tobase64(mac.doFinal())
	}


    public function oAuth(required method, required version, required url, urlParams, body){
            
        //build the parameters
        if (NOT isDefined('urlParams')){
            urlParams = {}
        }
        
        //Build all the required params by the oAuth API
        params = {}

        // Loop through urlParams and add them to params structure
        keys = structKeyArray(urlParams)

        for(i in keys){
            params[i]=urlParams[i]
        }

        //Base URL
        urlString = arguments.url
        
        //consumer key
        oauth_consumer_key = application.twitter_apiKey
        params.oauth_consumer_key = oauth_consumer_key

        //consumer secret
        consumer_secret = application.twitter_apiKeySecret

        //token secret
        token_secret = application.twitter_access_token_secret

        //Signing Key
        signing_key = consumer_secret&'&'&token_secret

        //nonce
        oauth_nonce = createUUID()
        oauth_nonce = replace(oauth_nonce,'-','','all')
        params.oauth_nonce = oauth_nonce

        //signature method
        oauth_signature_method = 'HMAC-SHA1'
        params.oauth_signature_method = oauth_signature_method
        
        //timestamp
        oauth_timestamp = getEpoch()
        params.oauth_timestamp = oauth_timestamp

        //Token
        oauth_token = application.twitter_access_token
        params.oauth_token = oauth_token

        //Version
        oauth_version = arguments.version
        params.oauth_version = oauth_version

        //we'll use this later
        appendChar = '&'
        
        //get the list of param keys
        keys = structKeyArray(params)
        
        //sort param keys
        arraySort(keys, 'textnocase', 'asc')
        
        //We'll use this later
        httpMethod = uCase(arguments.method)
        
        //Create the http service
        httpService = new http(method = httpMethod, url = urlString)
        
        //build the parameter string for oAuth
        paramString = ""
        
        //Loop through params to build paramstring
        for(i=1; i <= ArrayLen(keys); i++){
            paramKey = RFC3986(LCase(keys[i]))
            paramValue = RFC3986(params[keys[i]])
            paramString = paramString&paramKey&'='&paramValue&appendChar
        }
        
        //Remove the last '&' from the param string
        paramString = Mid(paramString,1,len(paramString)-1);
        
        //Create the signature base string
        baseString = httpMethod&appendChar&RFC3986(urlString)&appendChar&RFC3986(paramString)
        
        //HASH-IT! HASH-IT REAL GOOD!
        signatureString = hmacSha1(signing_key, baseString);

        authHeader = 'OAuth'

        authHeader = authHeader&' oauth_consumer_key="'&oauth_consumer_key&'",'

        authHeader = authHeader&'oauth_token="'&oauth_token&'",'

        authHeader = authHeader&'oauth_signature_method="'&oauth_signature_method&'",'

        authHeader = authHeader&'oauth_timestamp="'&oauth_timestamp&'",'

        authHeader = authHeader&'oauth_nonce="'&oauth_nonce&'",'

        authHeader = authHeader&'oauth_version="'&oauth_version&'",'

        authHeader = authHeader&'oauth_signature="'&RFC3986(signatureString)&'"'

        // Add the URL params to http service
        urlkeys = structKeyArray(urlParams)

        arraySort(urlkeys, 'textnocase', 'asc')

        for(i=1; i <= ArrayLen(urlkeys); i++){

            httpService.addParam(name = LCase(urlkeys[i]), type = 'URL', value = urlParams[urlkeys[i]])
        }

        if(isDefined('arguments.body')){

            body = serializeJSON(arguments.body)
            httpService.addParam(name = 'Content-type', type = 'header', value = 'application/json')
            httpService.addParam(type='body', value=body)

        }

        //Add the signature to http param as a header
        httpService.addParam(name = 'Authorization', type = 'header', value = authHeader)
            
        //send the request to api
        apiResponse = httpService.send().getPrefix()

        if(apiResponse.status_code==200){
            apiResponse = deserializeJSON(apiResponse.filecontent)
        }else{
            apiResponse = ''
        }

        return apiResponse
    }

}