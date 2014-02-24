# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canvas_client/version'

Gem::Specification.new do |spec|
  spec.name          = "canvas_client"
  spec.version       = CanvasClient::VERSION
  spec.authors       = ["David Furber"]
  spec.email         = ["furberd@gmail.com"]
  spec.summary       = %q{Ruby client for Canvas LMS API}
  spec.description   = %q{This gem provides a wrapper for Instructure's Canvas LMS JSON REST API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'
  spec.add_dependency 'virtus'
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-spec'
  spec.add_development_dependency 'minitest-spec-context'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
end
