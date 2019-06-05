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
|credentials myCredential|
credentials := UsersCredentials new.
myCredential := credentials credentialsTo: 'me'.
	googleTaskClient := GoogleTaskClient 
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl 
]

{ #category : #'as yet unclassified' }
TaskListTest >> tearDown [
	googleTaskClient :=nil.
]

{ #category : #'as yet unclassified' }
TaskListTest >> testCreateTaskListOffLineAbm [
	| taskList |
	taskList := TaskList offLine: 'lista de tarea offline test'.
	self deny: taskList isPersistant.
	taskList title: 'titulo modificado'.
	self assert: taskList title = 'titulo modificado'. taskList remove.
	self deny: taskList active
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOffLineToOnline [
	| taskList |
	taskList := TaskList offLine: 'tarea offLine'.
	self deny: taskList isPersistant.
	taskList onLine.
	self assert: taskList isPersistant.
	taskList remove.
	self deny: taskList isPersistant.
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOnLineAbm [
	| taskList tituloAnterior|
	taskList := TaskList onLine: 'lista de tarea offline test'.
	self assert: taskList isPersistant.
	tituloAnterior := taskList title.
	taskList title: 'modificando titulo'.
	self deny: taskList title = tituloAnterior .
	taskList remove.
	self deny: taskList isPersistant.
]
