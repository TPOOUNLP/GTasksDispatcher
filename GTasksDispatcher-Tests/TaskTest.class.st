Class {
	#name : #TaskTest,
	#superclass : #TestCase,
	#instVars : [
		'googleTaskClient',
		'googleTaskHttpClient',
		'agenda'
	],
	#category : #'GTasksDispatcher-Tests'
}

{ #category : #accessing }
TaskTest >> agenda: anObject [
	agenda := anObject
]

{ #category : #'as yet unclassified' }
TaskTest >> setUp [
	googleTaskClient := GoogleTaskClient
		new: '984973766290-m0kts2gcb86bn6alib1bolp54i1nc3i2.apps.googleusercontent.com'
		secret: 'wdK3pYvR4tApDCIU0B7pMaBz5'
		redirectUrl: 'http://localhost:8100/sso-google-callback'.

]

{ #category : #'as yet unclassified' }
TaskTest >> tearDown [
	googleTaskClient := nil.
]

{ #category : #'as yet unclassified' }
TaskTest >> testAbmTaskOffLine [
	| taskList task |
	taskList := TaskList offLine: 'taskList'.
	task := Task title: 'unaTarea' andTaskList: taskList.
	self deny: task isPersist.
	task title: 'Test'.
	self assert: task title = 'Test'.
	task remove.
	self deny: task active
]

{ #category : #'as yet unclassified' }
TaskTest >> testAbmTaskOnLine [
	| taskList task|
	taskList := TaskList onLine: 'taskList'.
	task := Task title: 'unaTarea' andTaskList: taskList.
	self assert: task isPersist.
	task title: 'Test'.
	self assert: task title = 'Test'.
	task remove
	
]

{ #category : #'as yet unclassified' }
TaskTest >> testAbmTaskOnLineOffLineToOnline [
	| taskList task |
	taskList := TaskList onLine: 'taskList'.
	task := Task title: 'unaTarea' andTaskList: taskList.
	self assert: task isPersist.
	task title: 'Test'.
	self assert: task title = 'Test'.
	task remove
]
