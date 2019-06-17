Class {
	#name : #ClientManager,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
ClientManager class >> instance [
	^ Instance
]

{ #category : #accessing }
ClientManager class >> instance: anObject [
	Instance := anObject
]

{ #category : #accessing }
ClientManager class >> new [
	(self instance) ifNil:[ self instance: ClientManager basicNew initialize].
	^self instance . 
]

{ #category : #accessing }
ClientManager class >> new: aKey secret: aSecretKey redirectUrl: anUrl [

self instance: (ClientManager basicNew initialize: aKey secret: aSecretKey redirectUrl: anUrl).
	^ self instance
]

{ #category : #initialization }
ClientManager class >> reset [
	self instance: nil
]

{ #category : #accessing }
ClientManager >> addTaskList: aTaskList [
	| tasklist |
	tasklist := (self
		jsonParser: '[' , (self server insertTasklist: aTaskList title) contents , ']'
		and: self taskListClass) first.
	aTaskList id: tasklist id.
	aTaskList title: tasklist title.
	aTaskList selfLink: tasklist selfLink
]

{ #category : #accessing }
ClientManager >> deleteTask: aTask inTaskList: aTaskList [
	self server deleteTask: aTask id inTasklist: aTaskList id.
	
]

{ #category : #accessing }
ClientManager >> deleteTaskList: aTaskList [
	self server deleteTaskList: aTaskList id.
	aTaskList id: nil.
	aTaskList tasks:OrderedCollection new.
]

{ #category : #accessing }
ClientManager >> getList [
	self server listTasklists .
]

{ #category : #accessing }
ClientManager >> getTaskLists [
	^ self
		loadTask:(self
		jsonParser: (self serialize: self server listTasklists contents)
		and: self taskListClass)
]

{ #category : #accessing }
ClientManager >> initialize [
|credentials myCredential|
credentials := UsersCredentials new.
myCredential := credentials getMyCredentials.
	self
		server:
			(GoogleTaskHttpClient
				key: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl ).
	ConfigurationOfZincHTTPComponents project latestVersion load: 'SSO'.
]

{ #category : #accessing }
ClientManager >> initialize: aKey secret: aSecretKey redirectUrl: anUrl [

	self
		server:
			(GoogleTaskHttpClient
				key: aKey 
				secret: aSecretKey 
				redirectUrl: anUrl ).
	ConfigurationOfZincHTTPComponents project latestVersion load: 'SSO'
]

{ #category : #accessing }
ClientManager >> insertTask: aTask inTaskList: aTaskList [
	| diccionario task |
	diccionario := Dictionary new.
	diccionario at: 'title' put: aTask title.
	diccionario at: #notes put: aTask notes.
	task := self
		taskParser: (self server insertTask: diccionario inTasklist: aTaskList id) contents.
	aTask id: task id
]

{ #category : #accessing }
ClientManager >> jsonParser: aJson [ 
	"devuelve un diccionario con los datos del json."

	^ NeoJSONReader fromString: aJson contents
]

{ #category : #accessing }
ClientManager >> jsonParser: aJson and: aClass [
	"devuelve un diccionario con los datos del json."

^ (NeoJSONReader on: aJson readStream)
		mapInstVarsFor: aClass;
		for: #Array customDo: [ :mapping | mapping listOfElementSchema: aClass ];
		nextAs: #Array
]

{ #category : #accessing }
ClientManager >> loadTask: tasksLists [
	^ tasksLists
		do: [ :taskList | 
			taskList
				tasks:
					(self
						jsonParser: (self serialize: (self server listTasks: taskList id) contents)
						and: self taskClass) asOrderedCollection ]
]

{ #category : #accessing }
ClientManager >> serialize: anObject [
	"	^NeoJSONWriter toString: ((NeoJSONReader fromString: anObject) at: 'items' ifAbsent: ['[]']).
"

	| items | 
	items := (NeoJSONReader fromString: anObject)
		at: 'items'
		ifAbsent: [ Array  new ].
	^ NeoJSONWriter toString: items
]

{ #category : #accessing }
ClientManager >> server [
	^ server
]

{ #category : #accessing }
ClientManager >> server: anObject [
	server := anObject
]

{ #category : #accessing }
ClientManager >> start [
	ConfigurationOfZincHTTPComponents project latestVersion load: 'SSO'.
]

{ #category : #accessing }
ClientManager >> taskClass [
 ^Task .
]

{ #category : #accessing }
ClientManager >> taskListClass [
	^ TaskList 
]

{ #category : #accessing }
ClientManager >> taskParser: aJson [
	^(NeoJSONReader on: aJson readStream)
		mapInstVarsFor: self taskClass;
		nextAs: self taskClass
]

{ #category : #accessing }
ClientManager >> updateTask: aTask inTaskList: aTaskList [
	| diccionario |
	diccionario := Dictionary new.
	diccionario at: 'title' put: aTask title.
	diccionario at: 'notes' put: aTask notes.
	diccionario at: 'status' put: aTask status.
	self server updateTask: aTask id inTasklist: aTaskList id withValues: diccionario
]

{ #category : #accessing }
ClientManager >> updateTaskList: aTaskList title: aTitle [
	self server updateTasklist: aTaskList id title: aTitle
]
