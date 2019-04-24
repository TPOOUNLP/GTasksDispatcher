"
I am ZnSSOServerDelegate, an example/test using SSO.

(ZnServer startOn: 8100)
	delegate: (ZnSSOServerDelegate new
		facebookData: (ZnOAuth2ConsumerData 
			key: '538399976180189'
			secret: '***************'
			redirectUrl: 'http://localhost:8100/sso-facebook-callback');
		googleData: (ZnOAuth2ConsumerData 
			key: '81499955779.apps.googleusercontent.com'
			secret: '***************'
			redirectUrl: 'http://localhost:8100/sso-google-callback');
		twitterData: (ZnOAuth1ConsumerData newForTwitterAuthentication 
			consumer: '5PAXu9CygKPD0aKwjnGdOA' ;
			consumerSecret: '*********');
		yourself);
	yourself.

"
Class {
	#name : #GoogleSSOServerDelegate,
	#superclass : #ZnDefaultServerDelegate,
	#instVars : [
		'googleData',
		'session'
	],
	#classVars : [
		'Session'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
GoogleSSOServerDelegate class >> session [
	^ Session
]

{ #category : #accessing }
GoogleSSOServerDelegate class >> session: anObject [
	Session := anObject
]

{ #category : #private }
GoogleSSOServerDelegate >> generateInvalidCallbackRequest [

	| html entity |

	html := String streamContents: [ :stream |
		stream
			nextPutAll: '<h3>Not a valid callback request</h3>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : #accessing }
GoogleSSOServerDelegate >> googleData [
	^ googleData
]

{ #category : #accessing }
GoogleSSOServerDelegate >> googleData: anObject [
	googleData := anObject
]

{ #category : #'accessing-session' }
GoogleSSOServerDelegate >> googleSessionFor: aRequest [
	^ aRequest session 
		attributeAt: 'google-session' 
		ifAbsentPut: [ ZnGoogleApisOAuth2Session data: self googleData ]
]

{ #category : #private }
GoogleSSOServerDelegate >> htmlPageTitled: title do: block [
	^ String streamContents: [ :stream |
		stream 
			<< '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>';
			<< title;
			<< '</title>
<style type="text/css">
body {
  color: black;
  background: white;
  width: 900px;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 13px;
}
p {
  width: 600px;
  padding: 0 5px 10px 0px;
} 
ul,ol {
  width: 600px;
  padding: 0 5px 5px 30px;
} 
#logo {
  color: orange;
  font-family: Helvetica, sans-serif;
  font-weight: bold;
  font-size: 100px;
}
</style>
</head>
<body>
<div id="logo">Zn</div>
<h1>'; 
			<< title; 
			<<'</h1>'. 
		block value: stream. 
		stream << '</body></html>' ]
]

{ #category : #'initialize-release' }
GoogleSSOServerDelegate >> initialize [

	super initialize.
	
	self prefixMap
		at: 'sso-demo' put: #ssoDemo: ;
		at: 'sso-reset' put: #ssoReset: ;
		at: 'sso-google' put: #ssoGoogle: ;
		at: 'sso-google-callback' put: #ssoGoogleCallback: ;
		at: 'sso-google-data' put: #ssoGoogleData:


]

{ #category : #testing }
GoogleSSOServerDelegate >> isOAuth2Callback: aRequest [

	^aRequest uri queryKeys includes: 'code'
]

{ #category : #private }
GoogleSSOServerDelegate >> manipulateDemoFile: dropboxUserAccess [
	"A little DropBox file manipulation demo."
	
	| demoFilePath contents id |
	demoFilePath := #( 'demo.txt' ).
	contents := [ dropboxUserAccess getFile: demoFilePath ] on: Error do: [ nil ].
	id := 0.
	contents ifNotNil: [ 
		contents linesDo: [ :line | | tokens |
			tokens := $: split: line.
			(tokens size >= 2 and: [ tokens first trimBoth = 'id' ])
				ifTrue: [ id := Integer readFrom: tokens second trimBoth ifFail: [ 0 ] ] ] ].
	id := id + 1.
	contents := String streamContents: [ :out |
		out << 'file:demo.txt'; crlf.
		out << 'description:created & updated automatically by ZnSSOServerDelegate>>#manipulateDemoFile:'; crlf.
		out << 'timestamp:'; print: DateAndTime now; crlf.
		out << 'id:'; print: id; crlf ].
	dropboxUserAccess putFile: demoFilePath data: (ZnEntity text: contents).
	^ id 
	
]

{ #category : #private }
GoogleSSOServerDelegate >> printDictionary: aDictionary asHtmlOn: aStream [

	aStream
		nextPutAll: '<ul>'.
	aDictionary keysAndValuesDo: [ :key :value |
		aStream
			nextPutAll: '<li>' ;
			nextPutAll: key.
		value isDictionary
			ifTrue: [ self printDictionary: value asHtmlOn: aStream ]
			ifFalse: [
				aStream
					nextPutAll: ' --> ' ;
					nextPutAll: value asString ].
		aStream nextPutAll: '</li>' ].
	aStream nextPutAll: '</ul>'
]

{ #category : #'accessing-session' }
GoogleSSOServerDelegate >> resetSessions: request [
	#(#google) do: [ :each | 
			request session removeAttribute: each , '-session' ]
]

{ #category : #accessing }
GoogleSSOServerDelegate >> session [
	^ session
]

{ #category : #accessing }
GoogleSSOServerDelegate >> session: anObject [
	session := anObject
]

{ #category : #responses }
GoogleSSOServerDelegate >> ssoDemo: request [
	| html session |
	html := self
		htmlPageTitled: 'Zinc SSO Demo'
		do: [ :stream | 
			stream << '<h2>OAuth2 Providers</h2>'.
			#(#Google)
				do: [ :each |
					session := self perform: (each asLowercase, 'SessionFor:') asSymbol with: request.
					stream
						<< '<a href="';
						<< session authenticationUrl asString;
						<< '" title="Login with ';
						<< each;
						<< '">';
						<< each;
						<< '</a>' ]
				separatedBy: [ stream << ' | ' ].
			
			stream << '<h4>May the Source be with you!</h4>' ].
	^ ZnResponse ok: (ZnEntity html: html)
]

{ #category : #responses }
GoogleSSOServerDelegate >> ssoGoogle: request [
	| googleSession |
	googleSession := self googleSessionFor: request.
	^ ZnResponse redirect: googleSession authenticationUrl asString
]

{ #category : #responses }
GoogleSSOServerDelegate >> ssoGoogleCallback: request [

	| googleSession |
	
	(self isOAuth2Callback: request)
		ifFalse: [ ^ self generateInvalidCallbackRequest ].

	googleSession := self googleSessionFor: request.
	googleSession handleAuthenticationCallback: request uri query.
	GoogleSSOServerDelegate session: googleSession.
	self session: googleSession.

	^ ZnResponse redirect: 'sso-google-data'
]

{ #category : #responses }
GoogleSSOServerDelegate >> ssoGoogleData: request [
	| googleSession userData html entity |
	googleSession := self googleSessionFor: request.
	userData := googleSession getUserData.
	html := self
		htmlPageTitled: 'Zinc SSO Google UserData'
		do: [ :stream | 
			stream << '<h3>Google UserData</h3>'.
			self printDictionary: userData asHtmlOn: stream.
			stream << ('</p><b>Token: </b>' , googleSession accessToken , '</p>').
			stream << ('</p><b>Token: </b>' , googleSession refreshToken , '</p>').
			stream << '<a href="sso-reset">Reset</a>' ].
	entity := ZnEntity html: html.
	^ ZnResponse ok: entity
]

{ #category : #responses }
GoogleSSOServerDelegate >> ssoReset: request [
	| target |
	self resetSessions: request.
	target := request uri queryAt: #target ifAbsent: [ 'sso-demo' ].
	^ ZnResponse redirect: target
]
