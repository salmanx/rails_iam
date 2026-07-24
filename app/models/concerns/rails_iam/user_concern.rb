# frozen_string_literal: true

module RailsIam
  module UserConcern
    extend ActiveSupport::Concern

    included do
      has_many :user_roles,
               class_name: "RailsIam::UserRole",
               foreign_key: :user_id,
               dependent: :destroy

      has_many :roles,
               through: :user_roles,
               source: :role

      has_many :user_permissions,
               class_name: "RailsIam::UserPermission",
               foreign_key: :user_id,
               dependent: :destroy

      has_many :granted_permissions,
               through: :user_permissions,
               source: :permission

      has_many :user_denied_permissions,
               class_name: "RailsIam::UserDeniedPermission",
               foreign_key: :user_id,
               dependent: :destroy

      has_many :denied_permissions,
               through: :user_denied_permissions,
               source: :permission

      has_many :refresh_tokens,
               class_name: "RailsIam::RefreshToken",
               foreign_key: :user_id,
               dependent: :destroy

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
