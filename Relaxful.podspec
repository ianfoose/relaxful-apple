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

s.platforms = { :ios => "8.0", :osx => "10.7", :watchos => "2.0", :tvos => "9.0" }

end
