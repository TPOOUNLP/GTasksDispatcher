Class {
	#name : #UsersCredentials,
	#superclass : #Object,
	#instVars : [
		'credentials'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
UsersCredentials >> credentialsTo: anUser [
	|credential |
	credential:= credentials at: 'mendiccini'.
	^ UserCredential key: (credential at: 'key') secret: (credential at: 'secret') redirectUrl: (credential at: 'redirectUrl')
	


]

{ #category : #accessing }
UsersCredentials >> initialize [
credentials:= NeoJSONReader fromString:
									'{
										"mendiccini" : {
											"key" : "620499193940-irnvqcb87lie5lb4u2ruuqp6gbfhl4mh.apps.googleusercontent.com",
											"secret" : "OqKLpsACkU7SsohLucVZ-LvN",
											"redirectUrl": "http://localhost:8080/sso-google-callback"
										},
										"perez" : { 
											"key" : "868363521190-htu9hve7g1l0215e8ahs48s0uerhompe.apps.googleusercontent.com",
											"secret" : "nYVZIR37unJV8QoH7mPAQ9F0",
											"redirectUrl": "http://localhost:8100/sso-google-callback"
										} }'.
]
