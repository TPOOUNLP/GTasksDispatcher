Class {
	#name : #Notifications,
	#superclass : #Object,
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

{ #category : #'as yet unclassified' }
Notifications >> getListsUpdatesByIds: googleTaskClient [
	^googleTaskClient getListsUpdatesByIds: googleTaskClient manager getTaskLists
]

{ #category : #'as yet unclassified' }
Notifications >> getTasksUpdatesByIds: lists [
	
	|dictionary|
	dictionary := Dictionary new.
	"lists do:[:list| list tasks do:[:task| dictionary at: task id put: task updated]]."
	lists do:[:list| list tasks do:[:task| dictionary add: task updateById]].
	^dictionary.
]

{ #category : #'as yet unclassified' }
Notifications >> getUpdatedInformation: merge from: googleTaskClient [
|list|
list:= Set new.
googleTaskClient manager getTaskLists do: [:taskList | taskList tasks do:[:task| (merge keys includes: task id) ifTrue: [list add: task]]].

^list.

]

{ #category : #'as yet unclassified' }
Notifications >> getUpdatedTasks: merge from: googleTaskClient [
|tasks cloudLists|
tasks:= Dictionary new.
cloudLists:= googleTaskClient manager getTaskLists.
merge keysDo: [ :key |  cloudLists do: [ :taskList | (taskList id = key) ifTrue: [ taskList tasks do:[:task| tasks at: task id put: task updated] ] ]].
^tasks.
]

{ #category : #accessing }
Notifications >> initialize [
	|   googleTaskClient updatedTasks updatedTasksUpdatesByIds mergeFromActualAndNextLists nextListsUpdatesByIds actualListsUpdatesByIds actualTasksUpdatesByIds|

	googleTaskClient := (MySession new) googleTaskClient .
	
	actualTasksUpdatesByIds := self getTasksUpdatesByIds: googleTaskClient taskLists.
	actualListsUpdatesByIds := self getListsUpdatesByIds: googleTaskClient.
	
[ 4 timesRepeat: [  	
	"50 second asDelay wait."
	Transcript show: 'Debes modificar alguna tarea! :)'.
	nextListsUpdatesByIds := self getListsUpdatesByIds: googleTaskClient.
	mergeFromActualAndNextLists := self merge: actualListsUpdatesByIds with: nextListsUpdatesByIds.

	updatedTasksUpdatesByIds:=self getUpdatedTasks: mergeFromActualAndNextLists from: googleTaskClient .
	mergeFromActualAndNextLists:= self merge: actualTasksUpdatesByIds with: updatedTasksUpdatesByIds .
	
	updatedTasks:= self getUpdatedInformation: mergeFromActualAndNextLists from: googleTaskClient.
	
	self updateAllInstances: updatedTasks.
	actualListsUpdatesByIds:= nextListsUpdatesByIds.
	actualTasksUpdatesByIds:= updatedTasksUpdatesByIds.
	
	
	updatedTasks := nil.
	nextListsUpdatesByIds := nil.
	updatedTasksUpdatesByIds := nil.
	mergeFromActualAndNextLists := nil.
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

{ #category : #'as yet unclassified' }
Notifications >> updateAllInstances: newList [
| newListIds instances instancesToUpdate|
	newListIds := newList collect: [ :each | each id ].
	instances:= 	Task allInstances .
	instancesToUpdate:=instances select:[:each | newListIds includes: each id].
	instancesToUpdate do:[:each| each setNewInformation: (newList detect:[ :task| task id = each id])].
	instances.
		


]
