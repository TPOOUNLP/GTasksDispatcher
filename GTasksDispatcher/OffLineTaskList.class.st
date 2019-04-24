Class {
	#name : #OffLineTaskList,
	#superclass : #State,
	#classVars : [
		'instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
OffLineTaskList class >> instance [
	^ instance
]

{ #category : #accessing }
OffLineTaskList class >> instance: anObject [
	instance := anObject
]

{ #category : #'as yet unclassified' }
OffLineTaskList >> deleteTask: aTask inTaskList: aTaskList [
	(aTaskList getTask: aTask ) active:false. 

	aTask isPersist ifFalse: [ super deleteTask: aTask inTaskList: aTaskList ]
		
]

{ #category : #'as yet unclassified' }
OffLineTaskList >> deleteTaskList: aTaskList [
	aTaskList active:false.
]

{ #category : #'as yet unclassified' }
OffLineTaskList >> offLine: aTaskList [

]

{ #category : #'as yet unclassified' }
OffLineTaskList >> onLine: aTaskList [
	aTaskList state: OnLineTaskList new.
	aTaskList state onLine:aTaskList 
]

{ #category : #'as yet unclassified' }
OffLineTaskList >> removeTaskList: aTaskList [
	aTaskList active: false	
]

{ #category : #'as yet unclassified' }
OffLineTaskList >> updateTask: aTask [

]

{ #category : #'as yet unclassified' }
OffLineTaskList >> updateTask: aTask andTaskList: aTaskList [
	| tasksyn |

	tasksyn := aTaskList getTaskById: aTask.
	tasksyn notes: aTask notes
]
