Class {
	#name : #TaskList,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'id',
		'title',
		'selfLink',
		'updated',
		'state',
		'active'
	],
	#category : #GTasksDispatcher
}

{ #category : #'as yet unclassified' }
TaskList class >> offLine: aTitle [
	^self new title: aTitle.


]

{ #category : #'as yet unclassified' }
TaskList class >> onLine: aTitle [
	| taskList |
	taskList := self new.
	taskList onLine.
	taskList title: aTitle.
	^ taskList
]

{ #category : #accessing }
TaskList >> = aTaskList [
	^ self id = aTaskList id
]

{ #category : #accessing }
TaskList >> active [
	^ active
]

{ #category : #accessing }
TaskList >> active: anObject [
	active := anObject
]

{ #category : #accessing }
TaskList >> addDeniedTask [
	^ (Error new messageText: 'No se puede agregar una tarea de una lista de tarea en otra') signal
]

{ #category : #accessing }
TaskList >> addTask: aTask [
	self state addTask: aTask inTaskList: self 
]

{ #category : #accessing }
TaskList >> deleteTask: aTask [
	self state deleteTask: aTask inTaskList: self.
]

{ #category : #accessing }
TaskList >> deleteTaskSimple: task [
	self state  deleteTask:task inTaskList:self.
]

{ #category : #accessing }
TaskList >> getIds: listTasks [
	^ listTasks collect: [ :task | task id ]
]

{ #category : #accessing }
TaskList >> getTask: aTask [
	^ self tasks detect: [ :task | task = aTask ] ifNone: [ nil ]
]

{ #category : #accessing }
TaskList >> getTaskById: aTask [
	^ self tasks detect: [ :task | task id= aTask id] ifNone: [ nil ]
]

{ #category : #accessing }
TaskList >> id [
	^ id
]

{ #category : #accessing }
TaskList >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
TaskList >> initialize [
	self tasks: OrderedCollection new.
	self state: OffLineTaskList new.
	self title: ' '.
	Task title: '' andTaskList: self.
	self active: true
]

{ #category : #accessing }
TaskList >> isPersist [
	^self id isNotNil 
]

{ #category : #accessing }
TaskList >> offLine [
	self state offLine:self
]

{ #category : #accessing }
TaskList >> onLine [
	self state onLine:self
]

{ #category : #accessing }
TaskList >> persist [
	self state persist
]

{ #category : #accessing }
TaskList >> remove [
	self state removeTaskList:self.
]

{ #category : #accessing }
TaskList >> selfLink [
	^ selfLink
]

{ #category : #accessing }
TaskList >> selfLink: anObject [
	selfLink := anObject
]

{ #category : #accessing }
TaskList >> setTitle: aTitle [
	title:= aTitle
]

{ #category : #accessing }
TaskList >> state [
	^ state
]

{ #category : #accessing }
TaskList >> state: anObject [
	state := anObject
]

{ #category : #accessing }
TaskList >> sync [
	| idsLocal idsNube |
	self syncDeletedTasks.
	idsLocal := self getIds: self tasks.
	idsNube := self getIds: self tasksInCloud.
	(self tasksInCloud reject: [ :task | idsLocal includes: task id ]) do: [ :taskNotLoad | self tasks add: taskNotLoad ].
	self tasks: (self tasks select: [ :task | idsNube includes: task id ]).
	
	^ self tasks
]

{ #category : #accessing }
TaskList >> syncDeletedTasks [
	(self tasks reject: [ :task | task active ])
		do: [ :task | self deleteTaskSimple: task ].
	self tasks do: [ :task | task active: true ]
]

{ #category : #accessing }
TaskList >> tasks [
	^ tasks
]

{ #category : #accessing }
TaskList >> tasks: anObject [
	tasks := anObject
]

{ #category : #accessing }
TaskList >> tasksInCloud [
	^ ((ClientManager new loadTask: (OrderedCollection with: self)) first tasks
		do: [ :task | task taskList: self ])
]

{ #category : #accessing }
TaskList >> title [
	^ title
]

{ #category : #accessing }
TaskList >> title: aTitle [
	self state updateTaskList: self andTitle: aTitle
]

{ #category : #'as yet unclassified' }
TaskList >> updateTask: aTask [
	self state updateTask: aTask andTaskList: self
	
]

{ #category : #accessing }
TaskList >> updated [
	^ updated
]

{ #category : #accessing }
TaskList >> updated: anObject [
	updated := anObject
]
