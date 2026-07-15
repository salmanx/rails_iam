# frozen_string_literal: true

require_relative "lib/rails_iam/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_iam"
  spec.version     = RailsIam::VERSION
  spec.authors     = ["Salman Mahmud"]
  spec.email       = ["salmanmahmud2014@gmail.com"]
  spec.homepage    = "https://github.com/salmanx/rails_iam"
  spec.summary     = "Identity and Access Management for rails application"
  spec.description = "will add later"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/salmanx/rails_iam"
  spec.metadata["changelog_uri"] = "https://github.com/salmanx/rails_iam"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "jwt", "~> 2.7"
  spec.add_dependency "rails", ">= 7.0"
end
