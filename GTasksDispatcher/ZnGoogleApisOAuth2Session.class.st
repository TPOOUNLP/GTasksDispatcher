Class {
	#name : #ZnGoogleApisOAuth2Session,
	#superclass : #ZnOAuth2Session,
	#instVars : [
		'accessType',
		'approvalPrompt',
		'dueDate'
	],
	#category : #GTasksDispatcher
}

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> data: aConsumerData [

	^ self new
		setConsumerData: aConsumerData ;
		yourself
]

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> scopeUserTasks [
	"Gain read-only access to basic profile information, including a user identifier, name, profile photo, 
	profile URL, country, language, timezone, and birthdate. "

	^ 'https://www.googleapis.com/auth/tasks'
]

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> scopeUserTasksReadOnly [
	"Gain read-only access to basic profile information, including a user identifier, name, profile photo, 
	profile URL, country, language, timezone, and birthdate. "

	^ 'https://www.googleapis.com/auth/tasks.readonly'
]

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> scopeUserinfoEmail [
	"Gain read-only access to the user's email address."

	^ 'https://www.googleapis.com/auth/userinfo.email'
]

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> scopeUserinfoProfile [
	"Gain read-only access to basic profile information, including a user identifier, name, profile photo, 
	profile URL, country, language, timezone, and birthdate. "

	^ 'https://www.googleapis.com/auth/userinfo.profile'
]

{ #category : #resources }
ZnGoogleApisOAuth2Session class >> ssoScopes [
	"Answer a collection of scopes that can be used for Authentication. "

	^ Array
		with: self scopeUserTasks
		with: self scopeUserTasksReadOnly
		with: self scopeUserinfoProfile
		with: self scopeUserinfoEmail
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> accessToken [
	DateAndTime current >= self dueDate
		ifTrue: [ self handleTokenRefresh ].
	^ accessToken
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> accessType [
	^ accessType
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> accessType: anObject [
	accessType := anObject
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> approvalPrompt [
	^ approvalPrompt
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> approvalPrompt: anObject [
	approvalPrompt := anObject
]

{ #category : #public }
ZnGoogleApisOAuth2Session >> authenticationUrl [

	^self authenticationUrlWithState: 'no-op'
]

{ #category : #public }
ZnGoogleApisOAuth2Session >> authenticationUrlWithState: aStateString [
	| authUrl |
	self initialize.
	authUrl := (ZnUrl fromString: 'https://accounts.google.com/o/oauth2/auth')
		queryAt: 'response_type' put: 'code';
		queryAt: 'client_id' put: self consumerData key;
		queryAt: 'redirect_uri' put: self redirectUrl;
		queryAt: 'scope' put: self scopeParameter;
		queryAt: 'state' put: aStateString;
		queryAt: 'access_type' put: self accessType;
		queryAt: 'prompt' put: 'consent';
		yourself.
		
	self isForceApprovalPrompt
		ifTrue: [ authUrl queryAt: 'prompt' put: 'force' ].
	^ authUrl
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> beOfflineAccessType [
	self accessType: 'offline'
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> beOnlineAccessType [
	self accessType: 'online'
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> dueDate [
	^ dueDate
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> dueDate: anObject [
	dueDate := anObject
]

{ #category : #accessing }
ZnGoogleApisOAuth2Session >> forceApprovalPrompt [
	self approvalPrompt: 'force'
]

{ #category : #public }
ZnGoogleApisOAuth2Session >> getUserData [

	| url response |
	
	url := (ZnUrl fromString: 'https://www.googleapis.com/oauth2/v1/userinfo')
		queryAt: 'access_token' put: self accessToken;
		yourself.

	response := ZnClient new get: url.
	
	^ NeoJSONReader fromString: response
]

{ #category : #public }
ZnGoogleApisOAuth2Session >> handleAuthenticationCallback: aParameterDictionary [
	| code tokenRequest tokenResponse tokenData |
	code := aParameterDictionary at: 'code' ifAbsent: [ ^ nil ].
	tokenRequest := (ZnRequest
		post: (ZnUrl fromString: 'https://accounts.google.com/o/oauth2/token'))
		entity:
			(ZnApplicationFormUrlEncodedEntity new
				at: 'code' put: code;
				at: 'client_id' put: self consumerData key;
				at: 'client_secret' put: self consumerData secret;
				at: 'redirect_uri' put: self redirectUrl;
				at: 'grant_type' put: 'authorization_code';
				yourself);
		yourself.
	tokenResponse := ZnClient new
		request: tokenRequest;
		post.
	tokenData := NeoJSONReader fromString: tokenResponse.
	
	accessToken := tokenData at: 'access_token'.
	dueDate := DateAndTime current + (tokenData at: 'expires_in').
	tokenType := tokenData at: 'token_type'.
	(tokenData includesKey: 'refresh_token')
		ifTrue: [ refreshToken := tokenData at: 'refresh_token' ]
]

{ #category : #public }
ZnGoogleApisOAuth2Session >> handleTokenRefresh [
	| tokenRequest tokenResponse tokenData |
	tokenRequest := (ZnRequest
		post: (ZnUrl fromString: 'https://accounts.google.com/o/oauth2/token'))
		entity:
			(ZnApplicationFormUrlEncodedEntity new
				at: 'client_id' put: self consumerData key;
				at: 'client_secret' put: self consumerData secret;
				at: 'grant_type' put: 'refresh_token';
				at: 'refresh_token' put: self refreshToken;
				yourself);
		yourself.
	tokenResponse := ZnClient new
		request: tokenRequest;
		post.
	tokenData := NeoJSONReader fromString: tokenResponse.
	(tokenData includesKey: 'error')
		ifTrue: [ Error signal: (tokenData at: 'error') asString ].
	accessToken := tokenData at: 'access_token'.
	tokenType := tokenData at: 'token_type'.
	dueDate := DateAndTime current + (tokenData at: 'expires_in').
]

{ #category : #'initialize-release' }
ZnGoogleApisOAuth2Session >> initialize [
	super initialize.
	self beOfflineAccessType.

]

{ #category : #testing }
ZnGoogleApisOAuth2Session >> isForceApprovalPrompt [
	^ self approvalPrompt notNil and: [ self approvalPrompt = 'force' ]
]

{ #category : #testing }
ZnGoogleApisOAuth2Session >> isOfflineAccessType [
	^ self accessType = 'offline'
]
