# frozen_string_literal: true

module RailsIam
  module Authentication
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        class_attribute :skip_authentication_rules, instance_accessor: false, default: []

        before_action :authenticate!
      end

      class_methods do
        def skip_authentication(only: nil, except: nil)
          self.skip_authentication_rules += [
            RailsIam::Authentication::SkipAuthenticationRule.new(
              only: only,
              except: except,
            ),
          ]
        end
      end

      def current_user
        RailsIam::Authentication::Current.user
      end

      private

      def authenticate!
        return if skip_authentication?

        RailsIam::Authentication::Current.user = RailsIam::Authentication::Authenticator.call(request)
      end

      def skip_authentication?
        self.class.skip_authentication_rules.any? do |rule|
          rule.matches?(action_name)
        end
      end
    end
  end
end
