# -*- encoding: utf-8 -*-
version = File.read(File.expand_path("../../SOLIDUS_VERSION", __FILE__)).strip

Gem::Specification.new do |gem|
  gem.author        = 'Solidus Team'
  gem.email         = 'contact@solidus.io'
  gem.homepage      = 'http://solidus.io/'

  gem.summary       = %q{REST API for the Solidus e-commerce framework.}
  gem.description   = gem.summary

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "solidus_api"
  gem.require_paths = ["lib"]
  gem.version       = version

  gem.add_dependency 'solidus_core', version
  gem.add_dependency 'rabl', ['>= 0.9.4.pre1', '< 0.12.0']
  gem.add_dependency 'versioncake', '~> 2.3.1'
end
