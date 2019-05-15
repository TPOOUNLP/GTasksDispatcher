Class {
	#name : #TaskListTest,
	#superclass : #TestCase,
	#instVars : [
		'googleTaskClient'
	],
	#category : #'GTasksDispatcher-Tests'
}

{ #category : #'as yet unclassified' }
TaskListTest >> setUp [
	googleTaskClient := GoogleTaskClient 
		new: '984973766290-m0kts2gcb86bn6alib1bolp54i1nc3i2.apps.googleusercontent.com'
		secret: 'dK3pYvR4tApDCIU0B7pMaBz5'
		redirectUrl: 'http://localhost:8100/sso-google-callback'
]

{ #category : #'as yet unclassified' }
TaskListTest >> tearDown [
	googleTaskClient :=nil.
]

{ #category : #'as yet unclassified' }
TaskListTest >> testCreateTaskListOffLineAbm [
	| taskList |
	taskList := TaskList offLine: 'lista de tarea offline test'.
	self deny: taskList isPersist.
	taskList title: 'titulo modificado'.
	self assert: taskList title = 'titulo modificado'. taskList remove.
	self deny: taskList active
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOffLineToOnline [
	| taskList |
	taskList := TaskList offLine: 'tarea offLine'.
	self deny: taskList isPersist.
	taskList onLine.
	self assert: taskList isPersist .
	taskList remove.
	self deny: taskList isPersist .
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOnLineAbm [
	| taskList tituloAnterior|
	taskList := TaskList onLine: 'lista de tarea offline test'.
	self assert: taskList isPersist.
	tituloAnterior := taskList title.
	taskList title: 'modificando titulo'.
	self deny: taskList title = tituloAnterior .
	taskList remove.
	self deny: taskList isPersist .
]
