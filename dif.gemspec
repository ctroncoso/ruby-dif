# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dif/version'

Gem::Specification.new do |spec|
  spec.name          = "dif"
  spec.version       = Dif::VERSION
  spec.authors       = ["Carlos Troncoso"]
  spec.email         = ["ctroncoso@thinkmint.cl"]
  spec.description   = %q{
    Dif provides a simple method to READ a dif (Data Interchange File Format),
    and convert to a standard CSV file.
    A WRITE module will follow in further versions, if there is any interest, 
    but as of now, being diff a legacy file format, the only use I've foud is 
    to read from them.}
  spec.summary       = %q{Provides a simple method to READ .dif files}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
