# frozen_string_literal: true

module RailsIam
  module Config
    class Jwt
      attr_accessor :secret,
                    :algorithm,
                    :issuer,
                    :audience,
                    :jwt_expires_in

      def initialize
        # Secret verification string used to sign security tokens.
        @secret = ENV["JWT_SECRET"].presence || Rails.application&.secret_key_base

        # Digital signature algorithm category mapping.
        @algorithm = "HS256"
        @jwt_expires_in = 15.minutes

        # Optional security claim validations (RFC 7519 standard targets).
        # Leave nil to disable strict validation checks.
        @issuer = nil
        @audience = nil
      end
    end
  end
end
