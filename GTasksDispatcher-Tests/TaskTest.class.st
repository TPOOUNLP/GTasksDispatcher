Class {
	#name : #TaskTest,
	#superclass : #TestCase,
	#instVars : [
		'googleTaskClient',
		'googleTaskHttpClient'
	],
	#category : #'GTasksDispatcher-Tests'
}

{ #category : #'as yet unclassified' }
TaskTest >> setUp [
	googleTaskClient := GoogleTaskClient
		new: '908090974740-50h6p604j68p5pltfjs7qm9sclg2bflj.apps.googleusercontent.com'
		secret: 'wl8nnK6nYl8I3i5ORswu0byf'
		redirectUrl: 'http://localhost:8200/sso-google-callback'.

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
