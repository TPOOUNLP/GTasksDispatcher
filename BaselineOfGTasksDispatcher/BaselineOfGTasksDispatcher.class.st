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
					with: [ spec requires: #('GTasksDispatcher') ];
				project: 'ZincHTTPComponents'
					with: [ spec
						className: 'ConfigurationOfZincHTTPComponents';
						repository: 'http://mc.stfx.eu/ZincHTTPComponents';
						loads: #('Core' 'SSO' 'REST' 'WebSocket');
						versionString: #stable ] ]
]

{ #category : #accessing }
BaselineOfGTasksDispatcher >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfGTasksDispatcher >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '0.1'.
]
