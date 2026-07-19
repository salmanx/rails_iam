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
      say "IMPORTANT NEXT STEP:", :yellow
      say "=======================================================", :yellow
      say "1. Open config/initializers/rails_iam.rb", :green
      say "2. Configure your user model mapping:", :green
      say "   • If you have an existing authentication model (e.g., User, Member, or Admin),", :green
      say "      - set 'config.user_class' to that model name string.", :green
      say "      - set 'config.current_user_method' to :current_user or :current_member", :green
      say "        that you used to refer authenticated user context.", :green
      say "      - Add `include RailsIam::UserConcern` to that model"
      say "   • If you want to use the default 'rails_iam' authentication,", :green
      say "     leave the configuration as it is.", :green
      say "3.  Run migrations:  bin/rails db:migrate", :green
      say "=======================================================\n", :yellow
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
