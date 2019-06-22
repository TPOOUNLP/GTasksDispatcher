Class {
	#name : #MySession,
	#superclass : #ZnOAuth2Session,
	#instVars : [
		'myCredential'
	],
	#category : #GTasksDispatcher
}

{ #category : #'initialize-release' }
MySession >> googleTaskClient [
	| credentials|
	credentials := UsersCredentials new.
	myCredential := credentials getMyCredentials.
	^GoogleTaskClient
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl.
]

{ #category : #'initialize-release' }
MySession >> myCredential [
	^myCredential 
]

{ #category : #'initialize-release' }
MySession >> myCredential: anObject [
	myCredential:= anObject  
]
