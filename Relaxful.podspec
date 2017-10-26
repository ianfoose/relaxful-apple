Pod::Spec.new do | s |

s.name = 'Relaxful'
s.version = '1.0.0'
s.summary = 'Rest API Client Framework'

s.author = {
	'Ian Foose' => 'ianfoose@me.com'
}

s.source = {
:git => ''
:tag => s.version.to_s
}

s.source_files = 'Source/*'

s.ios.minimum_deployment_target = '8.0'

s.tvos.minimum_deployment_target = '8.0'

s.watchos.minimum_deployment_target = '2.0'

s.macos.minimum_deployment_target = '10.0'

end
