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
	| credentials myCredential |
	credentials := CredentialsGithub new.
	myCredential := credentials credentialsTo: 'me'.
	googleTaskClient := GoogleTaskClient
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl
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
