# frozen_string_literal: true

require "jwt"

module RailsIam
  module Authentication
    class JwtDecoder < RailsIam::RailsIamService
      include RailsIam::ConfigLoader

      class InvalidToken < StandardError; end

      def initialize(token, headers = {})
        super()
        @token = token
        @headers = headers
      end

      def call
        decoded = JWT.decode(
          token,
          jwt_secret_key,
          true,
          { algorithm: jwt_algorithm, verify_jti: true }.merge(headers),
        )

        decoded.first.deep_symbolize_keys
      rescue JWT::ExpiredSignature
        raise InvalidToken, token_expired_error
      rescue JWT::DecodeError
        raise InvalidToken, token_error
      end

      private

      attr_reader :token, :headers
    end
  end
end
