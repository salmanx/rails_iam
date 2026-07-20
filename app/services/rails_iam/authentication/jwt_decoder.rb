# frozen_string_literal: true

require "jwt"

module RailsIam
  module Authentication
    class JwtDecoder < RailsIam::RailsIamService
      class InvalidToken < StandardError; end

      def initialize(token)
        super()
        @token = token
      end

      def call
        decoded = JWT.decode(
          token,
          jwt_secret_key,
          true,
          { algorithm: jwt_algorithm, verify_jti: true },
        )

        decoded.first.deep_symbolize_keys
      rescue JWT::ExpiredSignature
        raise InvalidToken, "Token expired"
      rescue JWT::DecodeError => e
        raise InvalidToken, e.message
      end

      private

      attr_reader :token
    end
  end
end
