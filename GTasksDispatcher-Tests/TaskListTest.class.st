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
myCredential := credentials getMyCredentials.
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
	self deny: taskList isPersistent.
	taskList title: 'titulo modificado'.
	self assert: taskList title = 'titulo modificado'. taskList remove.
	self deny: taskList active
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOffLineToOnline [
	| taskList |
	taskList := TaskList offLine: 'tarea offLine'.
	self deny: taskList isPersistent.
	taskList onLine.
	self assert: taskList isPersistent.
	taskList remove.
	self deny: taskList isPersistent.
]

{ #category : #'as yet unclassified' }
TaskListTest >> testTaskListOnLineAbm [
	| taskList tituloAnterior|
	taskList := TaskList onLine: 'lista de tarea offline test'.
	self assert: taskList isPersistent.
	tituloAnterior := taskList title.
	taskList title: 'modificando titulo'.
	self deny: taskList title = tituloAnterior .
	taskList remove.
	self deny: taskList isPersistent.
]
