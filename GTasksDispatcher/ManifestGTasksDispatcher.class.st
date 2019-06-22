"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGTasksDispatcher,
	#superclass : #PackageManifest,
	#category : #'GTasksDispatcher-Manifest'
}

{ #category : #'code-critics' }
ManifestGTasksDispatcher class >> ruleRBConsistencyCheckRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#Notifications #notifications #false)) #'2019-06-18T23:12:09.626995-03:00') )
]
