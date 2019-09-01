Class {
	#name : #UsersCredentials,
	#superclass : #Object,
	#instVars : [
		'credentials'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
UsersCredentials >> getMyCredentials [
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
										"username" : { 
											"key" : "aKey",
											"secret" : "aSecret",
											"redirectUrl": "http://localhost:8080/sso-google-callback"
										} }'.
]
