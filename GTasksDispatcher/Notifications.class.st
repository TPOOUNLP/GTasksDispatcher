Class {
	#name : #Notifications,
	#superclass : #Object,
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #'as yet unclassified' }
Notifications >> actualizeAllInstances2: newList [
	| newListIds pos instances x|
	newListIds := newList collect: [ :each | each id ].
	pos := 1.
	instances:= 	Task allInstances .
	x:=instances select:[:each | newListIds includes: each id].
	x do:[:each| each setNewInformation: (newList detect:[ :task| task id = each id])].
	"Task allInstancesDo: [ :instance | 
			(newListIds includes: instance id)
				ifTrue: [ (instances at: pos)
						setNewInformation: (newList detect: [ :list | list id = instance id ]) ].
			pos := pos + 1 ].
	"instances.
		

]

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
list:= Set new.
googleTaskClient manager getTaskLists do: [:taskList | taskList tasks do:[:task| (merge keys includes: task id) ifTrue: [list add: task]]].

^list.

]

{ #category : #'as yet unclassified' }
Notifications >> hacerAlgoCon: list and: googleTaskClient [
|tasks|
tasks:= Dictionary new.
list keysDo: [ :key | (googleTaskClient manager getTaskLists)  do: [ :taskList | (taskList id = key) ifTrue: [ taskList tasks do:[:task| tasks at: task id put: task updated] ] ]].
^tasks.
]

{ #category : #'as yet unclassified' }
Notifications >> initialize [
	| actual next merge googleTaskClient newList x b|

	googleTaskClient := (MySession new) googleTaskClient .
	b:= Dictionary new.
	googleTaskClient taskLists do:[:list| list tasks do:[:task| b at: task id put: task updated]].
	actual := self getListsIdsAndUpdates: googleTaskClient.
	
"[ 4 timesRepeat: [  	
	50 second asDelay wait."
	next:= Dictionary new.
	next := self getListsIdsAndUpdates: googleTaskClient.
	merge := self merge: actual with: next.
	
	"HASTA ACA NOS QUEDAMOS CON LAS LISTAS DE TAREAS QUE TIENEN TAREAS ACTUALIADAS"
	x:=self hacerAlgoCon: merge and: googleTaskClient .

	merge:= self merge: b with: x.
	
	newList:= self getNewInformation: merge from: googleTaskClient.
	self actualizeAllInstances2: newList.
	newList := String new.
	actual:= next.
	next:= String new.
"]	] forkAt: Processor userBackgroundPriority" ']'
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
