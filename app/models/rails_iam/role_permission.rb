# frozen_string_literal: true

module RailsIam
  class RolePermission < ApplicationRecord
    belongs_to :permission, class_name: "RailsIam::Permission"
    belongs_to :role, class_name: "RailsIam::Role"

    validates :permission_id, uniqueness: { scope: :role_id }

    after_commit :clear_user_permission_caches

    private

    def clear_user_permission_caches
      role.users.find_each do |user|
        RailsIam::Authorization::Cache.delete_all(user.id)
      end
    end
  end
end
