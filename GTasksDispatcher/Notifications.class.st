Class {
	#name : #Notifications,
	#superclass : #Object,
	#classVars : [
		'Instance'
	],
	#category : #GTasksDispatcher
}

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
	| credentials myCredential actual next merge googleTaskClient newList |
	credentials := UsersCredentials new.
	myCredential := credentials getMyCredentials.
	googleTaskClient := GoogleTaskClient
		new: myCredential key
		secret: myCredential secret
		redirectUrl: myCredential redirectUrl.
	
	"Armo un diccionario (1) con los campos ids y updates de la nube"
	actual := self getListsIdsAndUpdates: googleTaskClient.
"[ 4 timesRepeat: [  	"
			
	"Armo un diccionario (2) con los campos ids y updates de la nube"
	next:= Dictionary new.
	next := self getListsIdsAndUpdates: googleTaskClient.
	
	"Comparo diccionar 1 y 2 y armo otro"
	merge := self merge: actual with: next.
	
	"Con las keys (ids) del diccionario merge, voy a la nube y traigo toda la info de las listas"
	newList:= self getNewInformation: merge from: googleTaskClient.
	
	"
	ACA DEBEMOS AVISAR A LAS TAREAS QUE ESTAN SIENDO USADAS QUE CAMBIARON
	newList do:[:each| ].!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	actual:= next.
"]	] forkAt: Processor userBackgroundPriority

Task title: x andTaskList: (TaskList onLine: 'listaUno')."
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
