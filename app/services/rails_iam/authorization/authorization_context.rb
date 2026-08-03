# frozen_string_literal: true

module RailsIam
  module Authorization
    class AuthorizationContext
      attr_reader :user,
                  :resolved_permissions,
                  :roles,
                  :required_roles,
                  :required_permissions,
                  :inferred_permission,
                  :role_match,
                  :permission_match

      def initialize(
        user:,
        required_roles: [],
        required_permissions: [],
        inferred_permission: nil,
        role_match: :any,
        permission_match: :all
      )
        @user = user
        @roles = RoleResolver.call(user)
        @resolved_permissions = PermissionResolver.call(user)
        @required_roles = required_roles.map(&:to_s)
        @required_permissions = required_permissions.map(&:to_s)
        @inferred_permission = inferred_permission
        @role_match = role_match
        @permission_match = permission_match
      end

      def permissions_for_check
        return required_permissions if required_permissions.any?
        return [inferred_permission] if inferred_permission.present?

        []
      end
    end
  end
end
