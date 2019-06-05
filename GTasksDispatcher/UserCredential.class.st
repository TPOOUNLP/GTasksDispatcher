Class {
	#name : #UserCredential,
	#superclass : #Object,
	#instVars : [
		'secret',
		'key',
		'redirectUrl'
	],
	#category : #GTasksDispatcher
}

{ #category : #'instance creation' }
UserCredential class >> key: aKey secret: aSecret redirectUrl: aRedirectUrl [
	^ self new
		key: aKey;
		secret: aSecret;
		redirectUrl: aRedirectUrl;
		initialize;
		yourself
]

{ #category : #accessing }
UserCredential >> key [
	^key
]

{ #category : #accessing }
UserCredential >> key: anObject [
	key:= anObject
]

{ #category : #accessing }
UserCredential >> redirectUrl [
	^redirectUrl
]

{ #category : #accessing }
UserCredential >> redirectUrl: anObject [
	redirectUrl:= anObject
]

{ #category : #accessing }
UserCredential >> secret [
	^secret
]

{ #category : #accessing }
UserCredential >> secret: anObject [
	secret:= anObject
]
