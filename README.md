# GTasksDispatcher
This project uses Google Tasks to decouple a "dispatcher" and "workker" roles.

Add your credentials to UsersCredentials >> initialize. For example:

"username" : { 
	"key" : "aKey",
	"secret" : "aSecret",
	"redirectUrl": "http://localhost:8080/sso-google-callback"
} 
                    
Then, set your username in UsersCredentials >> getMyCredentials

	|credential |
	credential:= credentials at: 'username'.
	^ UserCredential key: (credential at: 'key') secret: (credential at: 'secret') redirectUrl: (credential at: 'redirectUrl')
	
To run the project, write the following in a Playground:
	Updater new 

