# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_on_lambda/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-on-lambda'
  spec.version       = RackOnLambda::VERSION
  spec.authors       = ['Joergen Ddahlke']
  spec.email         = ['joergen.dahlke@gmail.com']

  spec.summary       = 'Write beautiful Ruby applications for AWS Lambda'
  spec.description   = 'Use your Rack application on AWS Lambda.'
  spec.homepage      = 'https://github.com/jdahlke/rack-on-lambda'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'activesupport', '~> 6.0'
  spec.add_dependency 'rack', '>= 2.0.8', '< 3'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
