# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rumba/crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "rumba-crawler"
  spec.version       = Rumba::Crawler::VERSION
  spec.authors       = ["Volodymyr Ladnik"]
  spec.email         = ["vladnik@abunkermode.com"]
  spec.summary       = %q{Extracting game score and other data from web pages}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 1.8.0"
  spec.add_dependency "em-http-request", "~> 1.0.3"
  spec.add_dependency "nokogiri", "~> 1.5.9"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
