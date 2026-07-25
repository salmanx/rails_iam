# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module RailsIam
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    def copy_migrations
      say "Copying migration file", :yellow
      migration_template "create_rails_iam_tables.rb.erb", "db/migrate/create_rails_iam_tables.rb"
    end

    def create_initializer
      say "Copying initializer file", :yellow
      template "initializer.rb", "config/initializers/rails_iam.rb"
    end

    def show_readme
      say "\n=======================================================", :yellow
      say " RailsIam installed successfully!", :green
      say "=======================================================", :yellow
      say "Next steps:", :yellow
      say ""
      say "1. Open: config/initializers/rails_iam.rb", :green
      say ""
      say "2. Configure your user model if you have an existing authentication model:", :green
      say "   • If you have existing authentication (Devise, Auth0, custom, etc.)", :green
      say "     - config.user_class = 'User' (or Account, Member, Admin...)", :green
      say "     - config.current_user_method = :current_user (or :current_account)", :green
      say "     - Add `acts_as_rails_iam_user` to your user (or Account, Member, Admin...) authentication  model.", :green
      say ""
      say "   • If your use RailsIam authentication", :green
      say "     - Keep the default configuration.", :green
      say ""
      say "3. Run: bin/rails db:migrate", :green
      say ""
      say "You're ready to start using RailsIam 🚀", :green
      say "=======================================================\n", :yellow
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
