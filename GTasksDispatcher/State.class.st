Class {
	#name : #State,
	#superclass : #Object,
	#instVars : [
		'taskList'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
State class >> new [
	self instance ifNil: [ self instance: self basicNew initialize ].
	^ self instance
]

{ #category : #'as yet unclassified' }
State >> addTask: aTask [
	self taskList add:aTask.
]

{ #category : #'as yet unclassified' }
State >> addTask: aTask inTaskList: aTaskList [
	aTaskList tasks add: aTask.
	aTask taskList: aTaskList
]

{ #category : #'as yet unclassified' }
State >> deleteTask: aTask [
	^ self taskList remove: aTask.
]

{ #category : #'as yet unclassified' }
State >> deleteTask: aTask inTaskList: aTaskList [
	aTaskList tasks remove: aTask
]

{ #category : #'as yet unclassified' }
State >> id:anId [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
State >> initialize [
	self taskList: OrderedCollection new
]

{ #category : #'as yet unclassified' }
State >> isOnline [
	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
State >> offLine: aTaskList [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
State >> onLine:aTaskList [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
State >> online [
	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
State >> persist [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
State >> removeTaskList:aTaskList [
	^self subclassResponsibility 

]

{ #category : #'as yet unclassified' }
State >> sync [
	^self subclassResponsibility 
]

{ #category : #accessing }
State >> taskList [
	^ taskList
]

{ #category : #accessing }
State >> taskList: anObject [
	taskList := anObject
]

{ #category : #accessing }
State >> title: aTitle andTaskList:aTaskList [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
State >> updateTaskList: aTaskList andTitle: aTitle [
	aTaskList setTitle: aTitle
]
