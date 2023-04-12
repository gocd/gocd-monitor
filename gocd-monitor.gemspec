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
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '1.14.3' # indirect dependency needed by cfpropertylist
  spec.add_dependency 'CFPropertyList', '2.2.8' # indirect dependency needed by facter

  spec.add_dependency 'faraday', '0.9.2'
  spec.add_dependency 'net-http-persistent', '2.9.4' # to allow keep alive/persistent http connections
  spec.add_dependency 'facter', '2.4.6'

  spec.add_development_dependency 'bundler', '1.12.5'
  spec.add_development_dependency 'rake', '13.0.6'
  spec.add_development_dependency 'rspec' , '3.4.0'
end
