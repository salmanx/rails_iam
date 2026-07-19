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

      def authorizer_arguments
        {
          required_roles: roles,
          required_permissions: permissions,
          role_match: role_match,
          permission_match: permission_match,
        }
      end
    end
  end
end
