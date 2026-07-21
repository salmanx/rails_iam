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
                    :access_token_expires_in,
                    :refresh_token_expires_in,
                    :token_error,
                    :token_expired_error,
                    :user_not_found_error,
                    :authentication_error

      def initialize
        # The key used when storing or reading the access token from cookies or parameters.
        @access_token_key = "access_token"

        # The key used when storing or reading the long-lived refresh token.
        @refresh_token_key = "refresh_token"

        # Authentication Strategy
        # Supported: [:cookie], [:bearer], or combined [:cookie, :bearer]
        @authentication_strategies = [:cookie]

        # Session Strategy, allowing user to login from multiple device at the same time
        # Supported: :single || :multi
        @session_strategy = :multi

        # Authentication Endpoints
        @sign_in_path = "/auth/sign_in"
        @sign_out_path = "/auth/sign_out"
        @refresh_token_path = "/auth/refresh"

        # expiry for access token
        @access_token_expires_in = 15.minutes
        @refresh_token_expires_in = 30.days

        # Authentication Messages
        @token_error = "The provided authentication token is invalid or malformed."
        @token_expired_error = "The authentication session has expired. Please re-authenticate."
        @user_not_found_error = "Invalid email address or password."
        @authentication_error = "Invalid email address or password."
      end
    end
  end
end
