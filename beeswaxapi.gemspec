
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "beeswaxapi/version"

Gem::Specification.new do |spec|
  spec.name          = "beeswaxapi"
  spec.version       = BeeswaxAPI::VERSION
  spec.authors       = ["Valentyn Ostakh"]
  spec.email         = ["valikos.ost@gmail.com"]

  spec.summary       = %q{Beeswax.com rest api client}
  spec.description   = %q{Simple ruby client to work with beeswax buzz api}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus", "~> 1.3"
  spec.add_dependency "dry-types", "~> 0.12.2"
  spec.add_dependency "dry-struct", "~> 0.4.0"
  spec.add_dependency "dry-configurable", "~> 0.7.0"  
  spec.add_dependency "yajl-ruby", "~> 1.3", ">= 1.3.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11.2"
end
