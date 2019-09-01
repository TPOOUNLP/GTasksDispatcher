Class {
	#name : #Updater,
	#superclass : #Object,
	#instVars : [
		'googleTaskClient'
	],
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
Updater >> execute [
|actualListsDictionary updatedListsDictionary actualTasksDictionary updatedTasksDictionary mergeFromActualAndUpdatedLists|
	googleTaskClient := (MySession new) googleTaskClient .
	actualTasksDictionary := self getTasksUpdatesByIds.
	actualListsDictionary := self getListsUpdatesByIds.
"[ 4 timesRepeat: ["  	
	"50 second asDelay wait."
	Transcript show: 'Debes modificar alguna tarea! :)'.
	updatedListsDictionary := self getListsUpdatesByIds.
	mergeFromActualAndUpdatedLists:= self merge: actualListsDictionary with: updatedListsDictionary.
	updatedTasksDictionary:= self getUpdatedTasks: mergeFromActualAndUpdatedLists.
	mergeFromActualAndUpdatedLists:= self merge: actualTasksDictionary with: updatedTasksDictionary.
	self updateInformation: mergeFromActualAndUpdatedLists.
	actualListsDictionary:= updatedListsDictionary.
	updatedListsDictionary := nil.
	actualTasksDictionary:= updatedTasksDictionary.
	updatedTasksDictionary := nil.
	mergeFromActualAndUpdatedLists := nil.
"]	] forkAt: Processor userBackgroundPriority"
]

{ #category : #'as yet unclassified' }
Updater >> getListsUpdatesByIds [
	^ googleTaskClient getListsUpdatesByIds
]

{ #category : #'as yet unclassified' }
Updater >> getTasksUpdatesByIds [
	^ googleTaskClient getTasksUpdatesByIds.
]

{ #category : #'as yet unclassified' }
Updater >> getUpdatedTasks: mergeFromActualAndUpdatedLists [
| cloudLists updatedTasksDictionary|
updatedTasksDictionary:= Dictionary new.
cloudLists:= googleTaskClient getTaskLists.
mergeFromActualAndUpdatedLists keysDo: [ :key |  cloudLists do: [ :taskList | (taskList id = key) ifTrue: [ taskList tasks do:[:task| updatedTasksDictionary at: task id put: task updated] ] ]].
^updatedTasksDictionary.
]

{ #category : #accessing }
Updater >> googleTaskClient [
	^ googleTaskClient .
]

{ #category : #accessing }
Updater >> googleTaskClient: anObject [
	googleTaskClient := anObject
]

{ #category : #accessing }
Updater >> initialize [
	self execute.
]

{ #category : #'as yet unclassified' }
Updater >> merge: actual with: next [
|mergeFromActualAndUpdatedLists|
mergeFromActualAndUpdatedLists:= Dictionary new.
	next keysDo: [ :key | 
			(actual includesKey: key)
				ifFalse: [ mergeFromActualAndUpdatedLists at: key put: (next at: key) ];
				ifTrue: [ ((actual at: key) = (next at: key)) ifFalse: [ mergeFromActualAndUpdatedLists at: key put: (next at:key) ]]].
	^ mergeFromActualAndUpdatedLists.
]

{ #category : #'as yet unclassified' }
Updater >> updateAllInstances: newList [
| newListIds instances instancesToUpdate|
	newListIds := newList collect: [ :each | each id ].
	instances:= 	Task allInstances .
	instancesToUpdate:=instances select:[:each | newListIds includes: each id].
	instancesToUpdate do:[:each| each setNewInformation: (newList detect:[ :task| task id = each id])].


]

{ #category : #'as yet unclassified' }
Updater >> updateInformation: mergeFromActualAndUpdatedLists [
|list|
list:= Set new.
googleTaskClient getTaskLists do: [:taskList | taskList tasks do:[:task| (mergeFromActualAndUpdatedLists keys includes: task id) ifTrue: [list add: task]]].
self updateAllInstances: list

]
