# frozen_string_literal: true

module RailsIam
  module Authorization
    class Authorizer < RailsIam::RailsIamService
      def initialize(
        user:,
        required_roles: [],
        required_permissions: [],
        inferred_permission: nil,
        role_match: :any,
        permission_match: :all
      )
        super()
        @context =
          AuthorizationContext.new(
            user: user,
            required_roles: required_roles,
            required_permissions: required_permissions,
            inferred_permission: inferred_permission,
            role_match: role_match,
            permission_match: permission_match,
          )
      end

      def call
        DeniedPermissionChecker.call(@context)
        RoleChecker.call(@context)
        PermissionChecker.call(@context)

        true # success is the absence of an exception
      end
    end
  end
end
