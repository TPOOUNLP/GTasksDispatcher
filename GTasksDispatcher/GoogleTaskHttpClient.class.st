"
GoogleTaskHttpClient 
		key: '984973766290-m0kts2gcb86bn6alib1bolp54i1nc3i2.apps.googleusercontent.com'
		secret: 'dK3pYvR4tApDCIU0B7pMaBz5'
		redirectUrl: 'http://localhost:8100/sso-google-callback'
"
Class {
	#name : #GoogleTaskHttpClient,
	#superclass : #Object,
	#instVars : [
		'sessionServer',
		'serverPort',
		'serviceUrl',
		'key',
		'secret',
		'redirectUrl'
	],
	#category : #GTasksDispatcher
}

{ #category : #'instance-creation' }
GoogleTaskHttpClient class >> key: aKey secret: aSecret redirectUrl: aRedirectUrl [
	^ self new
		key: aKey;
		secret: aSecret;
		redirectUrl: aRedirectUrl;
		initialize;
		yourself
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> clearTasklist: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/clear?access_token='
				, GoogleSSOServerDelegate session accessToken;
		entity: (ZnEntity with: '' type: ZnMimeType applicationJson);
		post;
		response
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> deleteTask: aTaskId inTasklist: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/tasks/' , aTaskId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		delete;
		response
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> deleteTaskList: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/users/@me/lists/' , aTasklistId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		delete;
		response
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> getTask: aTaskId inTasklist: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/tasks/' , aTaskId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		get;
		response
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> getTaskList: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/users/@me/lists/' , aTasklistId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		get;
		response
]

{ #category : #initialization }
GoogleTaskHttpClient >> initialize [
	| consumer authenticator |
	consumer := ZnOAuth2ConsumerData
		key: self key
		secret: self secret
		redirectUrl: self redirectUrl.
	authenticator := GoogleSSOServerDelegate new
		googleData: consumer;
		yourself.
	self
		serverPort: 8100;
		sessionServer:
			((ZnServer startDefaultOn: self serverPort)
				delegate: authenticator;
				yourself);
		serviceUrl: 'https://www.googleapis.com/tasks/v1'
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> insertTask: aAttributeMap inTasklist: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/tasks?access_token='
				, GoogleSSOServerDelegate session accessToken;
		entity: (ZnEntity with: (NeoJSONWriter toString: aAttributeMap) type: ZnMimeType applicationJson);
		post;
		response
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> insertTasklist: aTasklistTitle [
	^ ZnClient new
		url:
		   self serviceUrl , '/users/@me/lists?access_token='
				, GoogleSSOServerDelegate session accessToken;
		entity: (ZnEntity with: '{"title":"' , aTasklistTitle , '"}' type: ZnMimeType applicationJson);
		post;
		response
]

{ #category : #accessing }
GoogleTaskHttpClient >> key [
	^ key
]

{ #category : #accessing }
GoogleTaskHttpClient >> key: anObject [
	key := anObject
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> listTasklists [
	^ ZnClient new
		url:
			self serviceUrl , '/users/@me/lists?access_token='
				, GoogleSSOServerDelegate session accessToken;
		get;
		response
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> listTasks: aTasklistId [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/tasks?access_token='
				, GoogleSSOServerDelegate session accessToken;
		get;
		response
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> moveTask: aTaskId inTasklist: aTasklistId withParent: aParentTaskId withPrevious: aPreviousTaskId [
	| url |
	url := self serviceUrl , '/lists/' , aTasklistId , '/tasks/' , aTaskId , '/move?'.
	aPreviousTaskId ifNotNil: [ url := url , 'previous=' , aPreviousTaskId , '&' ].
	aParentTaskId ifNotNil: [ url := url , 'parent=' , aParentTaskId , '&' ].
	url := url , 'access_token=' , GoogleSSOServerDelegate session accessToken.
	^ ZnClient new
		url: url;
		entity: (ZnEntity with: '' type: ZnMimeType applicationJson);
		post;
		response
]

{ #category : #accessing }
GoogleTaskHttpClient >> redirectUrl [
	^ redirectUrl
]

{ #category : #accessing }
GoogleTaskHttpClient >> redirectUrl: anObject [
	redirectUrl := anObject
]

{ #category : #accessing }
GoogleTaskHttpClient >> secret [
	^ secret
]

{ #category : #accessing }
GoogleTaskHttpClient >> secret: anObject [
	secret := anObject
]

{ #category : #accessing }
GoogleTaskHttpClient >> serverPort [
	^ serverPort
]

{ #category : #accessing }
GoogleTaskHttpClient >> serverPort: anObject [
	serverPort := anObject
]

{ #category : #accessing }
GoogleTaskHttpClient >> serviceUrl [
	^ serviceUrl
]

{ #category : #accessing }
GoogleTaskHttpClient >> serviceUrl: anObject [
	serviceUrl := anObject
]

{ #category : #accessing }
GoogleTaskHttpClient >> sessionServer [
	^ sessionServer
]

{ #category : #accessing }
GoogleTaskHttpClient >> sessionServer: anObject [
	sessionServer := anObject
]

{ #category : #'task-management' }
GoogleTaskHttpClient >> updateTask: aTaskId inTasklist: aTasklistId withValues: aAttributeMap [
	^ ZnClient new
		url:
			self serviceUrl , '/lists/' , aTasklistId , '/tasks/' , aTaskId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		entity: (ZnEntity with: (NeoJSONWriter toString: aAttributeMap) type: ZnMimeType applicationJson);
		patch;
		response
]

{ #category : #'tasklist-management' }
GoogleTaskHttpClient >> updateTasklist: aTasklistId title: aNewTasklistTitle [
	^ ZnClient new
		url:
			self serviceUrl , '/users/@me/lists/' , aTasklistId , '?access_token='
				, GoogleSSOServerDelegate session accessToken;
		entity: (ZnEntity with: '{"title":"' , aNewTasklistTitle , '"}' type: ZnMimeType applicationJson);
		patch;
		response
]
