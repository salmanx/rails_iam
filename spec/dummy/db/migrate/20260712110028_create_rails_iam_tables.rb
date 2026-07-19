# frozen_string_literal: true

migration_version = "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"

class CreateRailsIamTables < ActiveRecord::Migration[migration_version.to_f]
  def change
    user_class_name = RailsIam.configuration&.user_class || "RailsIam::User"
    user_table_name = user_class_name.underscore.pluralize.tr("/", "_")

    create_table :rails_iam_users do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_roles do |t|
      t.string :name, index: { unique: true }
      t.text :description

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_permissions do |t|
      t.string :code, index: { unique: true }
      t.text :description

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_user_roles do |t|
      t.references :user, null: false,  foreign_key: { to_table: user_table_name }
      t.references :role, null: false,  foreign_key: { to_table: :rails_iam_roles }

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_user_permissions do |t|
      t.references :permission, null: false, foreign_key: { to_table: :rails_iam_permissions }
      t.references :user, null: false, foreign_key: { to_table: user_table_name }

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_role_permissions do |t|
      t.references :permission, null: false, foreign_key: { to_table: :rails_iam_permissions }
      t.references :role, null: false, foreign_key: { to_table: :rails_iam_roles }

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_user_denied_permissions do |t|
      t.references :permission, null: false, foreign_key: { to_table: :rails_iam_permissions }
      t.references :user, null: false, foreign_key: { to_table: user_table_name }

      # Custom Audit Tracking Columns
      t.string :created_by
      t.string :updated_by
      t.timestamp :deleted_at
      t.string :deleted_by

      t.timestamps
    end

    create_table :rails_iam_refresh_tokens do |t|
      t.references :user, null: false, foreign_key: { to_table: user_table_name }
      t.string :token_digest, index: { unique: true }
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.datetime :last_used_at
      # Jti from access token
      t.string :jti, index: { unique: true }
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
