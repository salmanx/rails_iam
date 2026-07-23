# frozen_string_literal: true

module RailsIam
  module Authentication
    class JwtEncoder < RailsIam::RailsIamService
      def initialize(user, extra_claims = {}, headers = {})
        super()
        @user = user
        @extra_claims = extra_claims
        @headers = headers
      end

      def call
        if jwt_secret_key.blank?
          raise RailsIam::Authentication::Exceptions::AuthenticationError,
                "Token generation failed due to a missing cryptographic configuration/jwt secret."
        end

        JWT.encode(payload, jwt_secret_key, jwt_algorithm, headers)
      rescue JWT::EncodeError => e
        raise RailsIam::Authentication::Exceptions::AuthenticationError e.message
      end

      private

      attr_reader :user, :extra_claims, :headers

      def payload
        # Base claims recommended by RFC 7519 standards
        claims = {
          sub: user&.id.to_s, # Standards recommend 'sub' string values
          email: user&.email,
          iat: Time.current.to_i,
          # nbf: Time.current.to_i, # Not Before: valid immediately
          exp: jwt_expiry.from_now.to_i,
        }

        claims[:iss] = jwt_issuer if jwt_issuer.present?
        claims[:aud] = jwt_audience if jwt_audience.present?

        claims.merge(extra_claims)
      end
    end
  end
end
