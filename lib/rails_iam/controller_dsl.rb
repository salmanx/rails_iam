# frozen_string_literal: true

module RailsIam
  module ControllerDsl
    extend ActiveSupport::Concern

    class_methods do
      def rails_iam(*features)
        features.each do |feature|
          case feature.to_sym
          when :authentication
            include RailsIam::Authentication::Authenticatable

            install_authentication_rescue_handler

          when :authorization
            include RailsIam::Authorization::Authorizable

            install_authorization_rescue_handler
          else
            raise ArgumentError, "Unknown RailsIam feature: #{feature.inspect}, only support :authentication and :authorization"
          end
        end
      end

      private

      def install_authentication_rescue_handler
        rescue_from RailsIam::Authentication::Exceptions::AuthenticationError do |exception|
          render_rails_iam_authentication_error(exception)
        end
      end

      def install_authorization_rescue_handler
        rescue_from RailsIam::Authorization::Exceptions::AuthorizationError do |exception|
          render_rails_iam_authorization_error(exception)
        end
      end
    end
  end
end
