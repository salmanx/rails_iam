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
      :infer_permission,
    ) do
      def matches?(action)
        action = action.to_sym

        return Array(only).map(&:to_sym).include?(action) if only.present?

        return Array(except).map(&:to_sym).exclude?(action) if except.present?

        true
      end

      def authorizer_arguments(controller_name:, action_name:)
        {
          required_roles: roles,
          required_permissions: required_permissions(controller_name, action_name),
          role_match: role_match,
          permission_match: permission_match,
        }
      end

      def valid?
        roles.any? || permissions.any? || infer_permission
      end

      private

      def required_permissions(controller_name, action_name)
        return permissions unless infer_permission

        [
          "#{controller_name.tr('/', '_').singularize}:#{action_name}",
        ]
      end
    end
  end
end
