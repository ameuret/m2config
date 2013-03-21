# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'm2config/version'

Gem::Specification.new do |spec|
  spec.name          = "m2config"
  spec.version       = M2Config::VERSION
  spec.authors       = ["Arnaud Meuret"]
  spec.email         = ["arnaud@meuret.net"]
  spec.description   = %q{A library to easily manage a Mongrel2 configuration database}
  spec.summary       = %q{Manage your Mongrel2 configuration database using handy model classes that map Servers, Hosts, Routes, Directories, Proxies, Handlers and Settings}
  spec.homepage      = "https://github.com/ameuret/m2config"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sqlite3"
  spec.add_dependency "sequel"
  spec.add_dependency "uuid"
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
