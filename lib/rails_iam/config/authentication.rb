# frozen_string_literal: true

module RailsIam
  module Config
    class Authentication
      attr_accessor :access_token_key,
                    :refresh_token_key,
                    :authentication_strategies,
                    :session_strategy,
                    :sign_in_path,
                    :sign_out_path,
                    :refresh_token_path,
                    :refresh_token_transport,
                    :access_token_expires_in,
                    :refresh_token_expires_in,
                    :token_error,
                    :token_expired_error,
                    :authentication_error,
                    :authentication_strategy_error,
                    :session_strategy_error,
                    :refresh_token_transport_error,
                    :cookie_options

      def initialize
        # The key used when storing or reading the access token from cookies or parameters.
        @access_token_key = "access_token"

        # The key used when storing or reading the long-lived refresh token.
        @refresh_token_key = "refresh_token"

        # Authentication Strategy
        # Supported: [:cookie], [:bearer], or combined [:cookie, :bearer]
        @authentication_strategies = %i[cookie]

        # Session Strategy, allowing user to login from multiple device at the same time
        # Supported: :single || :multi
        @session_strategy = :single

        # Determines how RailsIam receives the refresh token for :bearer strategy
        # Supported: :header || :request_body
        @refresh_token_transport = :header

        # Authentication Endpoints
        @sign_in_path = "/auth/sign_in"
        @sign_out_path = "/auth/sign_out"
        @refresh_token_path = "/auth/refresh"

        # expiry for access token
        @access_token_expires_in = 15.minutes
        @refresh_token_expires_in = 30.days

        # cookie options
        @cookie_options = { httponly: true, secure: Rails.env.production?, same_site: :lax }.freeze

        # Authentication Messages
        @token_error = "The provided authentication token is invalid or malformed."
        @token_expired_error = "The authentication token has expired. Please re-authenticate."
        @authentication_error = "Invalid email or password."
        @authentication_strategy_error = "Unknown authentication strategy. Please configure it from rails_iam initializer"
        @session_strategy_error = "Unknown session strategy. Please configure it from rails_iam initializer"
        @refresh_token_transport_error = "Unknown refresh token transport. Please configure it from rails_iam initializer"
      end
    end
  end
end
