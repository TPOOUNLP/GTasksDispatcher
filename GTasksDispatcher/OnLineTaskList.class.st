Class {
	#name : #OnLineTaskList,
	#superclass : #State,
	#classVars : [
		'instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
OnLineTaskList class >> instance [
	^ instance
]

{ #category : #accessing }
OnLineTaskList class >> instance: anObject [
	instance := anObject
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> addTask: aTask inTaskList: aTaskList [
	"si la task no esta persistida en alguna taskList, se agrega"

	aTask isPersistant
		ifTrue: [ ^ aTaskList addDeniedTask ]
		ifFalse: [ aTask persist.
			super addTask: aTask inTaskList: aTaskList ]
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> deleteTask: aTask inTaskList: aTaskList [
	GoogleTaskClient new deleteTask: aTask inTaskList: aTaskList.
	super deleteTask: aTask inTaskList: aTaskList
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> offLine: aTaskList [
	aTaskList state: OffLineTaskList new.
	
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> onLine: aTaskList [
	self sync: aTaskList.
	
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> removeTaskList: aTaskList [

	GoogleTaskClient new deleteTaskList: aTaskList .
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> sync: aTaskList [
	aTaskList isPersistant ifTrue: [ self updateTaskList: aTaskList andTitle: aTaskList title ] 
		ifFalse: [ ClientManager new addTaskList: aTaskList ].
	self syncTasks: aTaskList.
	GoogleTaskClient new addTaskList: aTaskList
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> syncTasks: aTaskList [
	aTaskList tasks do: [ :task | task modified ifTrue: [task persistAndUpdate ]].
	aTaskList sync
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> upDateTaskList: aTaskList [
ClientManager new updateTaskList: aTaskList  title: aTaskList title.
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> updateTask: aTask [
	aTask update.
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> updateTask: aTask andTaskList:aTaskList [
	|tasksyn|
	aTask update.
	tasksyn := aTaskList getTaskById: aTask .
	tasksyn notes:aTask notes.
	
]

{ #category : #'as yet unclassified' }
OnLineTaskList >> updateTaskList: aTaskList andTitle: aTitle [
	ClientManager new updateTaskList: aTaskList title: aTitle.
	super updateTaskList: aTaskList  andTitle: aTitle
]
