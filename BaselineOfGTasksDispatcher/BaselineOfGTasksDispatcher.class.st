Class {
	#name : #BaselineOfGTasksDispatcher,
	#superclass : #BaselineOf,
	#category : #BaselineOfGTasksDispatcher
}

{ #category : #baselines }
BaselineOfGTasksDispatcher >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Packages"
			spec
				package: 'GTasksDispatcher';
				package: 'GTasksDispatcher-Tests'
					with: [ spec requires: #('GTasksDispatcher') ] ]
]

{ #category : #accessing }
BaselineOfGTasksDispatcher >> projectClass [
	^ MetacelloCypressBaselineProject
]
