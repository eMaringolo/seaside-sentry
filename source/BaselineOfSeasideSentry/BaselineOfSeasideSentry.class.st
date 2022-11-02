Class {
	#name : #BaselineOfSeasideSentry,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeasideSentry
}

{ #category : #baselines }
BaselineOfSeasideSentry >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self seaside: spec.
		spec baseline: 'Sentry' with: [ 
			spec
				loads: #( 'Core' );
				repository: 'github://emaringolo/pharo-sentry:master/repository' ].
		spec
			package: 'Seaside-Sentry'
			with: [ spec requires: #( 'Seaside3' 'Sentry' ) ].
		spec
			group: 'Core' with: #( 'Seaside-Sentry' );
			group: 'default' with: #( 'Core' ) ]
]

{ #category : #baselines }
BaselineOfSeasideSentry >> seaside: spec [

	spec baseline: 'Seaside3' with: [ 
		spec
			loads: #( 'default' );
			repository: 'github://SeasideSt/Seaside:master/repository' ]
]
