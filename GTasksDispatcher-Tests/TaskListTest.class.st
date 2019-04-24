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
		new: '908090974740-50h6p604j68p5pltfjs7qm9sclg2bflj.apps.googleusercontent.com'
		secret: 'wl8nnK6nYl8I3i5ORswu0byf'
		redirectUrl: 'http://localhost:8200/sso-google-callback'
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
