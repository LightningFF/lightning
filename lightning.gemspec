require_relative 'lib/lightning/version'

Gem::Specification.new do |spec|
  spec.name        = 'lightningff'
  spec.version     = Lightning::VERSION
  spec.authors     = ['Ruthwick Pathireddy', 'Pranav Singh']
  spec.email       = ['ruthwickp@gmail.com', 'pranav@getcadet.com']
  spec.homepage    = 'https://github.com/LightningFF/lightning'
  spec.summary     = 'Feature flagging for Rails'
  spec.description = 'With Lightning, you can set up an end-to-end highly customizable feature flagging system in <1 minute. It provides console and UI support for feature flag management.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.1.3', '>= 6.1.3.2'
end
