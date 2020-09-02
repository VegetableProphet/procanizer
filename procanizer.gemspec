require_relative 'lib/procanizer/version'

Gem::Specification.new do |spec|
  spec.name          = "procanizer"
  spec.version       = Procanizer::VERSION
  spec.authors       = ["VegetableProphet"]
  spec.email         = ["slepoy.homyachok@gmail.com"]

  spec.summary       = "Small helper for automatic proc generation."
  spec.description   = "Generates procs for given instance methods to use for chaining."
  spec.homepage      = "https://github.com/VegetableProphet/procanizer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake",  "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
