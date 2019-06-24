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
	| credentials googleTaskClient |
	credentials := UsersCredentials new.
	myCredential := credentials getMyCredentials.
	googleTaskClient := GoogleTaskClient
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl.
	
	googleTaskClient taskLists: googleTaskClient manager getTaskLists .
	^googleTaskClient 
]

{ #category : #'initialize-release' }
MySession >> myCredential [
	^myCredential 
]

{ #category : #'initialize-release' }
MySession >> myCredential: anObject [
	myCredential:= anObject  
]
