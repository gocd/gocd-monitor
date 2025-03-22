# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gocd/monitor/version'

Gem::Specification.new do |spec|
  spec.name          = 'gocd-monitor'
  spec.version       = Gocd::Monitor::VERSION
  spec.authors       = ['Ganesh Patil']
  spec.email         = ['ganeshpl@thoughtworks.com']

  spec.summary       = %q{GoCD monitoring tool}
  spec.description   = %q{GoCD monitoring tool}
  spec.homepage      = 'https://github.com/gocd/gocd-monitor'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '1.18.5' # indirect dependency needed by cfpropertylist
  spec.add_dependency 'CFPropertyList', '3.0.7' # indirect dependency needed by facter

  spec.add_dependency 'faraday', '2.12.2'
  spec.add_dependency 'net-http-persistent', '4.0.5' # to allow keep alive/persistent http connections
  spec.add_dependency 'facter', '4.10.0'

  spec.add_development_dependency 'rake', '13.2.1'
  spec.add_development_dependency 'rspec' , '3.13.0'
end
