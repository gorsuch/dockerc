# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerc/version'

Gem::Specification.new do |spec|
  spec.name          = "dockerc"
  spec.version       = Dockerc::VERSION
  spec.authors       = ["Michael Gorsuch"]
  spec.email         = ["michael.gorsuch@gmail.com"]
  spec.summary       = %q{Yet another docker client.}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'excon'
  spec.add_dependency 'yajl-ruby'
    
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
