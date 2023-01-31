
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "objectified/version"

Gem::Specification.new do |spec|
  spec.name          = "objectified"
  spec.version       = Objectified::VERSION
  spec.authors       = ["Guilherme Andrade"]
  spec.email         = ["guilherme.andrade.ao@gmail.com"]

  spec.summary       = 'A simple mixin with meta coding utilities'
  spec.description   = 'Extract resource based object names with ease.'
  spec.homepage      = 'https://github.com/guilherme-andrade/objectified'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = 'https://github.com/guilherme-andrade/objectified'
    spec.metadata["changelog_uri"] = 'https://github.com/guilherme-andrade/objectified/Changelog.md'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*', 'Changelog.md', 'README.md']
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>=2.5.0'

  spec.add_dependency "activesupport", ">= 6.0.3", "< 7.1.0"
end
