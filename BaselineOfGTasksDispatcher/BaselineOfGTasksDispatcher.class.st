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
		do: [ spec package: 'BaselineOfGTasksDispatcher'.
			spec group: 'default' with: #('FileDialog') ]
]

{ #category : #accessing }
BaselineOfGTasksDispatcher >> projectClass [
	^ MetacelloCypressBaselineProject
]
