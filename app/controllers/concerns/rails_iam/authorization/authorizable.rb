# frozen_string_literal: true

module RailsIam
  module Authorization
    module Authorizable
      extend ActiveSupport::Concern
      include RailsIam::AuthConcern
      include RailsIam::ConfigLoader

      included do
        class_attribute :authorization_rules, instance_accessor: false, default: []
        class_attribute :skip_authorization_rules, instance_accessor: false, default: []
        before_action :run_authorization!
        rescue_from RailsIam::Authorization::Exceptions::AuthorizationError, with: :render_rails_iam_authorization_error
        rescue_from RailsIam::Authentication::Exceptions::AuthenticationError, with: :render_rails_iam_authentication_error
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

      def run_authorization!
        return if skip_authorization?

        user = current_authenticated_user

        authorize_any!(authorization_rules!, user)
      end

      def authorize_any!(rules, user)
        last_error = nil

        rules.each do |rule|
          authorize!(**rule.authorizer_arguments, user: user)
          return true
        rescue RailsIam::Authorization::Exceptions::AuthorizationError => e
          last_error = e
        end

        raise(last_error || RailsIam::Authorization::Exceptions::AuthorizationError.new)
      end

      def current_authenticated_user
        user_method = RailsIam.configuration.current_user_method

        raise RailsIam::Authentication::Exceptions::AuthenticationError, token_error unless respond_to?(user_method, true)

        user = public_send(user_method)

        raise RailsIam::Authentication::Exceptions::AuthenticationError, token_error if user.nil?

        user
      end

      def authorization_rules!
        rules = authorization_rules.reject do |rule|
          rule.roles.empty? && rule.permissions.empty?
        end

        if rules.empty?
          raise RailsIam::Authorization::Exceptions::AuthorizationError,
                authorization_rule_error
        end

        rules
      end

      def authorize!(
        user:, required_roles: [],
        required_permissions: [],
        role_match: :any,
        permission_match: :all
      )
        RailsIam::Authorization::Authorizer.call(
          user: user,
          required_roles: required_roles,
          required_permissions: required_permissions,
          role_match: role_match,
          permission_match: permission_match,
        )
      end

      def authorization_rules
        self.class.authorization_rules.select do |rule|
          rule.matches?(action_name)
        end
      end

      def skip_authorization?
        excluded_controller? || skipped_action?
      end

      def skipped_action?
        self.class.skip_authorization_rules.any? do |rule|
          rule.matches?(action_name)
        end
      end

      def excluded_controller?
        excluded_controller_patterns.any? do |pattern|
          self.class.name.match?(pattern)
        end
      end
    end
  end
end
