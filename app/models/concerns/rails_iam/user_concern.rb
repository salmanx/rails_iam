# frozen_string_literal: true

module RailsIam
  module UserConcern
    extend ActiveSupport::Concern

    included do
      has_many :user_roles, dependent: :destroy, class_name: "RailsIam::UserRole"
      has_many :roles, through: :user_roles, class_name: "RailsIam::Role"

      has_many :user_permissions, dependent: :destroy, class_name: "RailsIam::UserPermission"
      has_many :granted_permissions, through: :user_permissions, source: :permission

      has_many :user_denied_permissions, dependent: :destroy, class_name: "RailsIam::UserDeniedPermission"
      has_many :denied_permissions, through: :user_denied_permissions, source: :permission

      scope :with_allowed_permissions, -> { includes(user_permissions: :permission) }
      scope :with_denied_permissions, -> { includes(user_denied_permissions: :permission) }
      scope :with_authorization, lambda {
        includes(
          roles: :permissions,
          user_permissions: :permission,
          user_denied_permissions: :permission,
        )
      }
    end

    def permission_codes
      RailsIam::Authorization::PermissionResolver.call(self).effective_codes.to_a
    end

    def role_names
      RailsIam::Authorization::RoleResolver.call(self).to_a
    end
  end
end
