Class {
	#name : #Session,
	#superclass : #ZnOAuth2Session,
	#instVars : [
		'credentials',
		'myCredential',
		'googleTaskClient'
	],
	#category : #GTasksDispatcher
}

{ #category : #'initialize-release' }
Session >> initialize [
myCredential:= (UsersCredentials new) getMyCredentials.
	googleTaskClient:= GoogleTaskClient 
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl.
]
