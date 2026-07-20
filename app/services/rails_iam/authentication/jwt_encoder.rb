# frozen_string_literal: true

module RailsIam
  module Authentication
    class JwtEncoder < RailsIam::RailsIamService
      def initialize(user, extra_claims = {})
        super()
        @user = user
        @extra_claims = extra_claims
      end

      def call
        JWT.encode(payload, jwt_secret_key, jwt_algorithm)
      end

      private

      attr_reader :user, :extra_claims

      def payload
        # Base claims recommended by RFC 7519 standards
        claims = {
          sub: user.id.to_s, # Standards recommend 'sub' string values
          email: user.email,
          iat: Time.current.to_i,
          # nbf: Time.current.to_i, # Not Before: valid immediately
          exp: jwt_expiry,
        }

        claims.merge(extra_claims)
      end
    end
  end
end
