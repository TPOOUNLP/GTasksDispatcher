Class {
	#name : #Task,
	#superclass : #Object,
	#instVars : [
		'taskList',
		'id',
		'title',
		'selfLink',
		'updated',
		'notes',
		'status',
		'active'
	],
	#category : #GTasksDispatcher
}

{ #category : #'as yet unclassified' }
Task class >> new [
	^ self basicNew initialize.
	"no debe usarse, solo para metodos"
]

{ #category : #'as yet unclassified' }
Task class >> taskList: aTaskList [
	
	^ self title: ' ' andTaskList: aTaskList .
]

{ #category : #'as yet unclassified' }
Task class >> title: aTitle andTaskList: aTaskList [
	| task |
	task := self new.
		task taskList: aTaskList.
	task title: aTitle.

	aTaskList addTask: task.
	^ task
]

{ #category : #accessing }
Task >> = anObject [
	^ self title = anObject title
]

{ #category : #accessing }
Task >> active [
	^ active
]

{ #category : #accessing }
Task >> active: anObject [
	active := anObject.

]

{ #category : #accessing }
Task >> deleteTask [
		self taskList deleteTask: self.
]

{ #category : #accessing }
Task >> id [
	^ id
]

{ #category : #accessing }
Task >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Task >> initialize [
	self setTitle: ' '.
	self active:true.
]

{ #category : #accessing }
Task >> isPersistant [
	^ self id isNotNil
]

{ #category : #accessing }
Task >> notes [
	^ notes
]

{ #category : #accessing }
Task >> notes: anObject [
	notes := anObject.
	self taskList updateTask: self
]

{ #category : #accessing }
Task >> persist [
	self isPersistant ifFalse: [ ClientManager new insertTask: self inTaskList: self taskList ]
]

{ #category : #accessing }
Task >> remove [
	active :=false.
	self taskList deleteTask: self
]

{ #category : #accessing }
Task >> selfLink [
	^ selfLink
]

{ #category : #accessing }
Task >> selfLink: anObject [
	selfLink := anObject.
	self taskList updateTask: self
]

{ #category : #accessing }
Task >> setTitle:aTitle [
"accesor de uso interno"
	title:=aTitle .
]

{ #category : #accessing }
Task >> status [
	^ status
]

{ #category : #accessing }
Task >> status: anObject [
	status := anObject.
	self taskList updateTask: self.
]

{ #category : #accessing }
Task >> taskList [
	^ taskList
]

{ #category : #accessing }
Task >> taskList: anObject [
	taskList := anObject
]

{ #category : #accessing }
Task >> title [
	^ title
]

{ #category : #accessing }
Task >> title: anObject [
	title := anObject.

]

{ #category : #accessing }
Task >> update [
	self isPersistant
		ifTrue: [ GoogleTaskClient new updateTask: self inTaskList: self taskList ]
]

{ #category : #accessing }
Task >> updated [
	^ updated
]

{ #category : #accessing }
Task >> updated: anObject [
	updated := anObject.
	self taskList updateTask: self
]
