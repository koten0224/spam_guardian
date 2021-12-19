lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spam_guardian/version"
# require "spam_guardian/validator"

Gem::Specification.new do |spec|
  spec.name          = "spam_guardian"
  spec.version       = SpamGuardian::VERSION
  spec.authors       = ["frank0224"]
  spec.email         = ["frank0224@gmail.com"]

  spec.summary       = "Spam Guardian" 
  spec.description   = "A gem to prevent your application to receive some spam email user."
  spec.homepage      = "https://github.com/koten0224/spam_guardian"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "git@github.com:koten0224/spam_guardian.git"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/koten0224/spam_guardian"
  spec.metadata["changelog_uri"] = "https://github.com/koten0224/spam_guardian"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "active_support", "~> 6.0.3"
end
