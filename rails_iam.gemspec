# frozen_string_literal: true

require_relative "lib/rails_iam/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_iam"
  spec.version     = RailsIam::VERSION
  spec.authors     = ["Salman Mahmud"]
  spec.email       = ["salmanmahmud2014@gmail.com"]
  spec.homepage    = "https://github.com/salmanx/rails_iam"
  spec.summary = "Authentication, authorization, RBAC, PBAC and IAM for Ruby on Rails."
  spec.description = <<~DESCRIPTION
    Rails IAM is a database-driven Identity and Access Management (IAM) engine
    for Rails applications. It provides JWT authentication, refresh tokens,
    role-based access control (RBAC), permission-based access control (PBAC),
    endpoint-first authorization, role and user permissions, explicit denied
    permissions, authorization caching, and automatic resource authorization
    for API and traditional Rails applications.
  DESCRIPTION

  spec.license = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/salmanx/rails_iam"
  spec.metadata["documentation_uri"] = "https://github.com/salmanx/rails_iam/wiki"
  spec.metadata["changelog_uri"] =
    "https://github.com/salmanx/rails_iam/releases"
  spec.metadata["bug_tracker_uri"] = "https://github.com/salmanx/rails_iam/issues"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir.chdir(__dir__) do
    Dir[
      "{app,config,db,lib}/**/*",
      "README.md",
      "LICENSE",
      "CHANGELOG.md",
      "CONTRIBUTING.md",
      "*.gemspec",
      "Rakefile",
    ]
  end

  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.7.0"
  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "jwt", "~> 2.7"
  spec.add_dependency "rails", ">= 7.0"
end
