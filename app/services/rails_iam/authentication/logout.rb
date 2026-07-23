# frozen_string_literal: true

module RailsIam
  module Authentication
    class Logout < RailsIam::RailsIamService
      def initialize(refresh_token: nil)
        super()

        @refresh_token = refresh_token
      end

      def call
        invalidate_refresh_token
      end

      private

      attr_reader :refresh_token

      def invalidate_refresh_token
        return unless refresh_token

        case session_strategy
        when :single
          refresh_token.user.refresh_tokens.delete_all
        when :multi
          refresh_token.destroy

        else
          raise RailsIam::Authentication::Exceptions::AuthenticationError, session_strategy_error
        end
      end
    end
  end
end
