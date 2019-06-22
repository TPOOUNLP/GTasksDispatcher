Class {
	#name : #Notifications,
	#superclass : #Object,
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #'as yet unclassified' }
Notifications >> actualizeAllInstances: newList [
	| newListIds pos |
	newListIds := newList collect: [ :each | each id ].
	pos := 1.
	TaskList allInstancesDo: [ :instance | 
			(newListIds includes: instance id)
				ifTrue: [ (TaskList allInstances at: pos)
						setNewInformation: (newList detect: [ :list | list id = instance id ]) ].
			pos := pos + 1 ]
]

{ #category : #'as yet unclassified' }
Notifications >> getListsIdsAndUpdates: googleTaskClient [
	^googleTaskClient getIdsAndUpdates: googleTaskClient manager getTaskLists
]

{ #category : #'as yet unclassified' }
Notifications >> getNewInformation: merge from: googleTaskClient [
|list|
list:= googleTaskClient manager getTaskLists.
^list select: [:each | merge keys includes: each id].

]

{ #category : #'as yet unclassified' }
Notifications >> initialize [
	| actual next merge googleTaskClient newList|

	googleTaskClient := (MySession new) googleTaskClient .
	actual := self getListsIdsAndUpdates: googleTaskClient.
	
[ 4 timesRepeat: [  	
	50 second asDelay wait.
	next:= Dictionary new.
	next := self getListsIdsAndUpdates: googleTaskClient.
	merge := self merge: actual with: next.
	newList:= self getNewInformation: merge from: googleTaskClient.
	self actualizeAllInstances: newList.
	newList := String new.
	actual:= next.
	next:= String new.
]	] forkAt: Processor userBackgroundPriority
]

{ #category : #'as yet unclassified' }
Notifications >> merge: actual with: next [

|merge|
merge := Dictionary new.
	next keysDo: [ :key | 
			(actual includesKey: key)
				ifFalse: [ merge at: key put: (next at: key) ];
				ifTrue: [ ((actual at: key) = (next at: key)) ifFalse: [ merge at: key put: (next at:key) ]]].
			
	^ merge.
]
