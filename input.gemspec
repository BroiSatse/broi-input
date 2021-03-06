
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'broi-input'
  spec.version       = '0.1.3'
  spec.authors       = ['broisatse']
  spec.email         = ['sklajn@gmail.com']

  spec.summary       = 'Simple ruby object to handle user inputs'
  spec.description   = 'Destructures incoming user input onto dry struct'
  spec.homepage      = 'https://github.com/BroiSatse/broi-input'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-validation', '~> 0.12'
  spec.add_dependency 'dry-struct', '~> 0.5'
  spec.add_dependency 'dry-monads', '~> 1.0'


  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'byebug'
end
