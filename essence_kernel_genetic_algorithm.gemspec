# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'essence_kernel_genetic_algorithm/version'

Gem::Specification.new do |spec|
  spec.name          = 'essence_kernel_genetic_algorithm'
  spec.version       = EssenceKernelGeneticAlgorithm::VERSION
  spec.authors       = ['Todd Sedano']
  spec.email         = ['professor@gmail.com']
  spec.summary       = %q{Generates SEMAT Essence Kernels using empirical data}
  spec.description   = %q{Using GA algorithms this generates candidate kernels}
  spec.homepage      = ""
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json', '~> 1.8.1'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
