# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libreservice/version'

Gem::Specification.new do |spec|
  spec.name          = "libreservice"
  spec.version       = Libreservice::VERSION
  spec.authors       = ["Andre Bernardes"]
  spec.email         = ["abernardes@gmail.com"]
  spec.description   = %q{Adds a service layer on top of the Libreconv gem}
  spec.summary       = %q{Adds a service layer on top of the Libreconv gem for document to PDF conversion}
  spec.homepage      = "http://github.com/abernardes/libreservice"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/libreservice"]

  spec.add_dependency "sinatra"
  spec.add_dependency "libreconv"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
