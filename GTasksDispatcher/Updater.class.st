Class {
	#name : #Updater,
	#superclass : #Object,
	#instVars : [
		'googleTaskClient',
		'updatedTasksDictionary',
		'mergeFromActualAndUpdatedLists',
		'updatedListsDictionary',
		'actualListsDictionary',
		'actualTasksDictionary'
	],
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #accessing }
Updater >> actualListsDictionary [
	^ actualListsDictionary
]

{ #category : #accessing }
Updater >> actualListsDictionary: anObject [
	actualListsDictionary := anObject
]

{ #category : #accessing }
Updater >> actualTasksDictionary [
	^ actualTasksDictionary
]

{ #category : #accessing }
Updater >> actualTasksDictionary: anObject [
	actualTasksDictionary := anObject
]

{ #category : #accessing }
Updater >> execute [
	googleTaskClient := (MySession new) googleTaskClient .
	actualTasksDictionary := self getTasksUpdatesByIds.
	actualListsDictionary := self getListsUpdatesByIds.
[ 4 timesRepeat: [  	
	"50 second asDelay wait."
	Transcript show: 'Debes modificar alguna tarea! :)'.
	updatedListsDictionary := self getListsUpdatesByIds.
	self merge: actualListsDictionary with: updatedListsDictionary.
	self getUpdatedTasks.
	self merge: actualTasksDictionary with: updatedTasksDictionary.
	self updateInformation.
	self restart.
]	] forkAt: Processor userBackgroundPriority
]

{ #category : #'as yet unclassified' }
Updater >> getListsUpdatesByIds [
	^ googleTaskClient getListsUpdatesByIds: googleTaskClient getTaskLists
]

{ #category : #'as yet unclassified' }
Updater >> getTasksUpdatesByIds [
	
	|dictionary|
	dictionary := Dictionary new.
	googleTaskClient taskLists do:[:list| list tasks do:[:task| dictionary add: task updateById]].
	^dictionary.
]

{ #category : #'as yet unclassified' }
Updater >> getUpdatedTasks [
| cloudLists|
updatedTasksDictionary:= Dictionary new.
cloudLists:= googleTaskClient getTaskLists.
mergeFromActualAndUpdatedLists keysDo: [ :key |  cloudLists do: [ :taskList | (taskList id = key) ifTrue: [ taskList tasks do:[:task| updatedTasksDictionary at: task id put: task updated] ] ]].
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

mergeFromActualAndUpdatedLists:= Dictionary new.
	next keysDo: [ :key | 
			(actual includesKey: key)
				ifFalse: [ mergeFromActualAndUpdatedLists at: key put: (next at: key) ];
				ifTrue: [ ((actual at: key) = (next at: key)) ifFalse: [ mergeFromActualAndUpdatedLists at: key put: (next at:key) ]]].
	^ mergeFromActualAndUpdatedLists.
]

{ #category : #accessing }
Updater >> mergeFromActualAndUpdatedLists [
	^ mergeFromActualAndUpdatedLists
]

{ #category : #accessing }
Updater >> mergeFromActualAndUpdatedLists: anObject [
	mergeFromActualAndUpdatedLists := anObject
]

{ #category : #'as yet unclassified' }
Updater >> restart [ 
	actualListsDictionary:= updatedListsDictionary.
	updatedListsDictionary := nil.
	actualTasksDictionary:= updatedTasksDictionary.
	updatedTasksDictionary := nil.
	mergeFromActualAndUpdatedLists := nil.

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
Updater >> updateInformation [
|list|
list:= Set new.
googleTaskClient getTaskLists do: [:taskList | taskList tasks do:[:task| (mergeFromActualAndUpdatedLists keys includes: task id) ifTrue: [list add: task]]].
self updateAllInstances: list

]

{ #category : #accessing }
Updater >> updatedListsDictionary [
	^ updatedListsDictionary
]

{ #category : #accessing }
Updater >> updatedListsDictionary: anObject [
	updatedListsDictionary := anObject
]

{ #category : #accessing }
Updater >> updatedTasksDictionary [
	^ updatedTasksDictionary
]

{ #category : #accessing }
Updater >> updatedTasksDictionary: anObject [
	updatedTasksDictionary := anObject
]
