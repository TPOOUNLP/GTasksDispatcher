# GTasksDispatcher
This project uses Google Tasks to decouple a "dispatcher" and "worker" roles.

In Pharo go to Tools, Iceberg and click in new. From the options select clone from github.com and fill with the information below:  


	Owner name: TPOOUNLP

	Project name: GTasksDispatcher

	Protocol: HTTPS

When you finish cloning the project, right click in GTasksDispatcher and in Metacello select Install baseline of GTasksDisparcher (Default) to get all the dependencies needed to run the project.

Add your credentials to UsersCredentials >> initialize. For example:

"username" : { 
	"key" : "aKey",
	"secret" : "aSecret",
	"redirectUrl": "http://localhost:8080/sso-google-callback"
} 
                    
Then, set your username in UsersCredentials >> getMyCredentials

	|credential|
	credential:= credentials at: 'username'.
	^ UserCredential key: (credential at: 'key') secret: (credential at: 'secret') redirectUrl: (credential at: 'redirectUrl')
	
To run the project, write the following in a Playground:

	GetTasksUpdates new 
	
Magic Happens

