# frozen_string_literal: true

module RailsIam
  module Authorization
    AuthorizationRule = Data.define(
      :roles,
      :permissions,
      :role_match,
      :permission_match,
      :only,
      :except,
    ) do
      def matches?(action)
        action = action.to_sym

        return Array(only).map(&:to_sym).include?(action) if only.present?

        return Array(except).map(&:to_sym).exclude?(action) if except.present?

        true
      end

      def authorizer_arguments(inferred_permission: nil)
        {
          required_roles: roles,
          required_permissions: permissions,
          inferred_permission: inferred_permission,
          role_match: role_match,
          permission_match: permission_match,
        }
      end

      def valid?
        roles.any? || permissions.any?
      end
    end
  end
end
