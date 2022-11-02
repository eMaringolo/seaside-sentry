Class {
	#name : #WASentryErrorHandler,
	#superclass : #WAErrorHandler,
	#instVars : [
		'parentHandler',
		'async'
	],
	#category : #'Seaside-Sentry-Handler'
}

{ #category : #'instance creation' }
WASentryErrorHandler class >> context: aRequestContext parentHandler: anExceptionHandler [

	^ (self context: aRequestContext)
		  parentHandler: anExceptionHandler;
		  yourself
]

{ #category : #accessing }
WASentryErrorHandler >> async [

	^ async ifNil: [ async := false ]
]

{ #category : #accessing }
WASentryErrorHandler >> async: aBoolean [

	async := aBoolean
]

{ #category : #actions }
WASentryErrorHandler >> handleError: exception [

	self sentryFilter ifNotNil: [ :filter | 
		self async
			ifTrue: [ 
				[ 
				[ self handleException: exception fromFilter: filter ] forkAt:
					Processor userBackgroundPriority ] ]
			ifFalse: [ self handleException: exception fromFilter: filter ] ].
	^ (parentHandler context: requestContext) handleError: exception
]

{ #category : #actions }
WASentryErrorHandler >> handleException: exception fromFilter: filter [

	| client |
	client := filter client.
	filter contextBlock ifNotNil: [ :block | block value: self ].
	^ client captureException: exception in: filter eventBlock
]

{ #category : #accessing }
WASentryErrorHandler >> parentHandler [

	^ parentHandler
]

{ #category : #accessing }
WASentryErrorHandler >> parentHandler: aClass [

	parentHandler := aClass
]

{ #category : #accessing }
WASentryErrorHandler >> sentryFilter [

	| filter |
	requestContext handlers
		detect: [ :one | 
			one filters anySatisfy: [ :each | each isSentryExceptionFilter ] ]
		ifFound: [ :handler | 
			handler filters
				detect: [ :each | each isSentryExceptionFilter ]
				ifFound: [ :exFilter | filter := exFilter ] ].
	^ filter
]
