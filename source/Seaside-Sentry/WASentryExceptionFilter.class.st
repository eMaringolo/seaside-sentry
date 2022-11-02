Class {
	#name : #WASentryExceptionFilter,
	#superclass : #WAExceptionFilter,
	#category : #'Seaside-Sentry-Filter'
}

{ #category : #processing }
WASentryExceptionFilter >> client [
	"Answer a new client for receiver."

	^self computeClient
]

{ #category : #processing }
WASentryExceptionFilter >> computeClient [

	^ SentryClient dsn: (self configuration at: #dsn)
]

{ #category : #configuration }
WASentryExceptionFilter >> defaultConfiguration [

	^WAUserConfiguration new
		addParent: WASentryExceptionFilterConfiguration instance;
		yourself
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

{ #category : #processing }
WASentryExceptionFilter >> parentExceptionHandler [

	^ self configuration at: #parentExceptionHandler
]

{ #category : #processing }
WASentryExceptionFilter >> reuseClient [
	"Answer whether receiver will reuse the existing client."

	^ self configuration at: #reuseClient
]
