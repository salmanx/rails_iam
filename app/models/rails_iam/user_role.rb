# frozen_string_literal: true

module RailsIam
  class UserRole < ApplicationRecord
    belongs_to :user, class_name: RailsIam.configuration.user_class
    belongs_to :role, class_name: "RailsIam::Role"

    validates :role_id, uniqueness: { scope: :user_id }

    after_commit -> { RailsIam::Authorization::Cache.delete_all(user_id) }
  end
end
