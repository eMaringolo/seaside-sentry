Class {
	#name : #WASentryErrorHandler,
	#superclass : #WAErrorHandler,
	#instVars : [
		'parentHandler'
	],
	#category : #'Seaside-Sentry-Handler'
}

{ #category : #'instance creation' }
WASentryErrorHandler class >> context: aRequestContext parentHandler: anExceptionHandler [

	^ (self context: aRequestContext)
		  parentHandler: anExceptionHandler;
		  yourself
]

{ #category : #actions }
WASentryErrorHandler >> handleError: exception [

	self sentryFilter ifNotNil: [ :filter | 
		[ 
		| client |
		client := filter client.
		filter contextBlock ifNotNil: [ :block | block value: self ].
		client captureException: exception in: filter eventBlock ] forkAt:
			Processor userBackgroundPriority ].
	^ (parentHandler context: requestContext) handleError: exception
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
