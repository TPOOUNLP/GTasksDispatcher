Class {
	#name : #GoogleTaskClient,
	#superclass : #Object,
	#instVars : [
		'taskLists',
		'manager'
	],
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
GoogleTaskClient class >> errorInstance [
	^ (Error new messageText: 'no hay un cliente google task instanciado!') signal
]

{ #category : #accessing }
GoogleTaskClient class >> instance [
	^ Instance
]

{ #category : #accessing }
GoogleTaskClient class >> instance: anObject [
	Instance := anObject
]

{ #category : #'as yet unclassified' }
GoogleTaskClient class >> new [
	self instance ifNil: [ self errorInstance  ].
	^ self instance
]

{ #category : #'as yet unclassified' }
GoogleTaskClient class >> new: aKey secret: aSecretKey redirectUrl: anUrl [
	self instance ifNil: [ self instance: (GoogleTaskClient basicNew initialize: aKey secret: aSecretKey redirectUrl: anUrl)
].
	^ self instance
]

{ #category : #accessing }
GoogleTaskClient >> addTaskList: aTaskList [
	(self getTaskListById: aTaskList id) ifNil: [ self taskLists add: aTaskList ] .self sync.
	^ aTaskList
]

{ #category : #accessing }
GoogleTaskClient >> deleteTask: aTask [
	self manager deleteTask: aTask inTaskList: aTask taskList.
	aTask id: nil.
	aTask taskList: nil .self sync
]

{ #category : #accessing }
GoogleTaskClient >> deleteTask: aTask inTaskList: aTaskList [
	 self manager deleteTask: aTask inTaskList: aTaskList.
	aTask id:nil.
	aTask taskList:nil.
]

{ #category : #accessing }
GoogleTaskClient >> deleteTaskList: aTaskList [
	self manager deleteTaskList: aTaskList.
	taskLists remove: aTaskList.
	self sync.
	
]

{ #category : #accessing }
GoogleTaskClient >> deleteTaskListSimple: aTaskList [
	self taskLists remove: aTaskList.
	self manager deleteTaskList: aTaskList
]

{ #category : #accessing }
GoogleTaskClient >> getIds:aTaskLists [
	^ aTaskLists collect: [ : taskList | taskList id ].
]

{ #category : #accessing }
GoogleTaskClient >> getTaskListById: anId [
	^ self taskLists detect: [ :taskList | taskList id = anId  ] ifNone: [ nil ]
]

{ #category : #accessing }
GoogleTaskClient >> getTaskListByTitle: anTitle [
	^ self taskLists detect: [ :taskList | taskList title = anTitle ] ifNone: [ nil ]
]

{ #category : #accessing }
GoogleTaskClient >> initialize [
	self taskLists: OrderedCollection new.
	self manager: ClientManager new. 
]

{ #category : #accessing }
GoogleTaskClient >> initialize: aKey secret: aSecretKey redirectUrl: anUrl [
	self manager:( ClientManager new: aKey secret: aSecretKey  redirectUrl: anUrl ).
	self initialize
]

{ #category : #accessing }
GoogleTaskClient >> insertTask: aTask inTaskList: aTaskList [
	| taskGoogle |
	taskGoogle := self manager insertTask: aTask inTaskList: aTaskList.
	aTaskList addTask: taskGoogle.
	taskGoogle taskList:aTaskList .
	^ taskGoogle
]

{ #category : #accessing }
GoogleTaskClient >> insertTaskList: aTaskList [
	self manager addTaskList: aTaskList
]

{ #category : #accessing }
GoogleTaskClient >> manager [
	^ manager
]

{ #category : #accessing }
GoogleTaskClient >> manager: anObject [
	manager := anObject
]

{ #category : #accessing }
GoogleTaskClient >> sync [
	| ids idsnube |
	ids := self getIds: self taskLists.
	idsnube := self getIds: self manager getTaskLists.
	(self manager getTaskLists reject: [ :taskList | ids includes: taskList id ])
		do: [ :taskListsNotLoad | self taskLists add: taskListsNotLoad ].
	self taskLists: (self taskLists select: [ :tasklist | idsnube includes: tasklist id ]).
	self syncDeletedTaskList .
	self taskLists do: [ :taskList | taskList sync ].
	^ self taskLists
]

{ #category : #accessing }
GoogleTaskClient >> syncDeletedTaskList [
	(self taskLists reject: [ :tasklist | tasklist active ]) do: [ :taskList | self deleteTaskListSimple: taskList ].
	self taskLists do:[:taskList| taskList active:true.]
]

{ #category : #accessing }
GoogleTaskClient >> taskLists [
	^ taskLists
]

{ #category : #accessing }
GoogleTaskClient >> taskLists: anObject [
	taskLists := anObject
]

{ #category : #accessing }
GoogleTaskClient >> updateTask: aTask inTaskList: aTaskList [
		
	^ self manager updateTask: aTask inTaskList: aTaskList
]

{ #category : #accessing }
GoogleTaskClient >> updateTaskList: aTaskList title: aTitle [
	self manager updateTaskList: aTaskList title: aTitle.
	self sync .
	(taskLists  detect: [ :lista | lista title = aTaskList title ])title: aTitle 
]
