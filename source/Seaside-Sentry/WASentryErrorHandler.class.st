Class {
	#name : #WASentryErrorHandler,
	#superclass : #WAErrorHandler,
	#instVars : [
		'client',
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

{ #category : #accessing }
WASentryErrorHandler >> client [ 
	"Answer the Sentry client of receiver."

	^client ifNil: [ client := self computeClient ]
]

{ #category : #accessing }
WASentryErrorHandler >> computeClient [

	requestContext handlers
		  detect: [ :one | 
			  one filters anySatisfy: [ :filter | filter isExceptionFilter ] ]
		  ifFound: [ :handler | 
			  handler filters
				  detect: [ :each | each isExceptionFilter ]
				  ifFound: [ :exFilter | ^exFilter client ] ].
	^nil
]

{ #category : #actions }
WASentryErrorHandler >> handleError: exception [

	self client ifNotNil: [ 
		[ 
		client
			captureException: exception
			in: [ :event | event level: 'error' ] ] forkAt:
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
