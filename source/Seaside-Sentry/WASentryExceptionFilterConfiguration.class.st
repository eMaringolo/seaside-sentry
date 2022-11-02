Class {
	#name : #WASentryExceptionFilterConfiguration,
	#superclass : #WAExceptionFilterConfiguration,
	#category : #'Seaside-Sentry-Filter'
}

{ #category : #description }
WASentryExceptionFilterConfiguration >> describeOn: config [

	super describeOn: config.
	(config url: #dsn)
		group: #sentry;
		comment: 'Sets Sentry''s DSN'.
	(config boolean: #reuseClient)
		group: #sentry;
		comment: 'When enabled will cause a single Sentry Client to be shared among all requests.';
		default: false;
		beAdvanced.
	(config classBinding: #parentExceptionHandler)
		group: #sentry;
		comment: 'Parent exception handler class to which handler will be delegated after reporting';
		default: WAExceptionHandler.		
]
