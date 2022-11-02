"
I'm a Sentry enabled Exception filter.

When an exception happens inside the handling of receiver, we will create a `WASentryErrorHandler` that will reference receiver to create a new SentryClient and obtain the eventBlock that will be used to configure the event before sending it.

You can also specify a contextBlock that should return a Dictionary that will be merged into the client SentryContext.

    Instance Variables
	eventBlock:		<Block> 
   contextBlock:	<Block>
"
Class {
	#name : #WASentryExceptionFilter,
	#superclass : #WAExceptionFilter,
	#instVars : [
		'eventBlock',
		'contextBlock'
	],
	#category : #'Seaside-Sentry-Filter'
}

{ #category : #processing }
WASentryExceptionFilter >> client [
	"Answer a new client for receiver."

	^ self computeClient
]

{ #category : #processing }
WASentryExceptionFilter >> computeClient [

	^ SentryClient dsn: (self configuration at: #dsn)
]

{ #category : #accessing }
WASentryExceptionFilter >> contextBlock [

	^ contextBlock
]

{ #category : #accessing }
WASentryExceptionFilter >> contextBlock: aBlock [

	contextBlock := aBlock
]

{ #category : #configuration }
WASentryExceptionFilter >> defaultConfiguration [

	^ WAUserConfiguration new
		  addParent: WASentryExceptionFilterConfiguration instance;
		  yourself
]

{ #category : #accessing }
WASentryExceptionFilter >> eventBlock [

	^ eventBlock
]

{ #category : #accessing }
WASentryExceptionFilter >> eventBlock: anObject [

	eventBlock := anObject
]

{ #category : #processing }
WASentryExceptionFilter >> handleFiltered: aRequestContext [

	| handler |
	handler := WASentryErrorHandler
		           context: aRequestContext
		           parentHandler: self parentExceptionHandler.
	handler handleExceptionsDuring: [ 
		WACurrentExceptionHandler
			use: handler
			during: [ self next handleFiltered: aRequestContext ] ]
]

{ #category : #initialization }
WASentryExceptionFilter >> initialize [ 

	super initialize.
	eventBlock := [:event | event ].
]

{ #category : #processing }
WASentryExceptionFilter >> isSentryExceptionFilter [

	^ true
]

{ #category : #processing }
WASentryExceptionFilter >> parentExceptionHandler [

	^ self configuration at: #parentExceptionHandler
]

{ #category : #processing }
WASentryExceptionFilter >> reuseClient [
	"Answer whether receiver will reuse the existing client."

	^ self configuration at: #reuseClient
]
