# frozen_string_literal: true

module RailsIam
  module Authorization
    module Authorizable
      extend ActiveSupport::Concern

      included do
        class_attribute :authorization_rules, instance_accessor: false, default: []
        class_attribute :skip_authorization_rules, instance_accessor: false, default: []

        before_action :run_authorization

        rescue_from RailsIam::Authorization::Exceptions::ForbiddenError,
                    with: :handle_rails_iam_forbidden_error
      end

      class_methods do
        # rubocop:disable Metrics/ParameterLists
        def authorize(
          roles: [],
          permissions: [],
          role_match: :any,
          permission_match: :all,
          only: nil,
          except: nil
        )
          self.authorization_rules += [
            RailsIam::Authorization::AuthorizationRule.new(
              roles: Array(roles),
              permissions: Array(permissions),
              role_match: role_match,
              permission_match: permission_match,
              only: only,
              except: except,
            ),
          ]
        end
        # rubocop:enable Metrics/ParameterLists

        def skip_authorization(only: nil, except: nil)
          self.skip_authorization_rules += [
            RailsIam::Authorization::SkipAuthorizationRule.new(
              only: only,
              except: except,
            ),
          ]
        end
      end

      private

      def run_authorization
        return if skip_authorization?

        user_method = RailsIam.configuration.current_user_method

        # TODO: will replace with Auth exception instead forbidden
        unless respond_to?(user_method, true)
          raise Authorization::Exceptions::ForbiddenError,
                "Authentication required"
        end

        active_user = public_send(user_method)

        rule = authorization_rule

        if rule.nil? || (rule.roles.empty? && rule.permissions.empty?)
          raise Authorization::Exceptions::ForbiddenError,
                "No authorization rule for #{controller_name}##{action_name}"
        end

        authorize!(**rule.authorizer_arguments, user: active_user)
      end

      def authorize!(
        user:, required_roles: [],
        required_permissions: [],
        role_match: :any,
        permission_match: :all
      )
        Authorization::Authorizer.call(
          user: user,
          required_roles: required_roles,
          required_permissions: required_permissions,
          role_match: role_match,
          permission_match: permission_match,
        )
      end

      def authorization_rule
        self.class.authorization_rules.find do |rule|
          rule.matches?(action_name)
        end
      end

      def skip_authorization?
        self.class.skip_authorization_rules.any? do |rule|
          rule.matches?(action_name)
        end
      end

      def handle_rails_iam_forbidden_error(exception)
        render json: {
          error: "Forbidden",
          message: exception.message,
        }, status: :forbidden
      end

      def handle_rails_iam_authentication_error(exception)
        render json: {
          error: "Unauthorized",
          message: exception.message,
        }, status: :unauthorized
      end
    end
  end
end
