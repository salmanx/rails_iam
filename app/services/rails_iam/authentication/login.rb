# frozen_string_literal: true

module RailsIam
  module Authentication
    class Login < RailsIam::RailsIamService
      include RailsIam::ConfigLoader

      def initialize(email:, password:, request: nil)
        super()

        @email = email.to_s.downcase.strip
        @password = password
        @request = request
      end

      def call
        user = user_class.find_by(email: email)

        raise RailsIam::Authentication::Exceptions::AuthenticationError, authentication_error unless user&.authenticate(password)

        jti = SecureRandom.uuid

        access_token = JwtEncoder.call(user, jti: jti)
        refresh_token = RefreshTokenEncoder.call

        if session_strategy == :single
          ActiveRecord::Base.transaction do
            remove_existing_sessions(user)
            create_refresh_token(user, refresh_token, jti)
          end
        else
          create_refresh_token(user, refresh_token, jti)
        end

        AuthenticatedUser.new(
          user: user,
          access_token: access_token,
          refresh_token: refresh_token,
          access_token_expires_in: access_token_expires_in.from_now,
          refresh_token_expires_in: refresh_token_expires_in.from_now,
        )
      end

      private

      attr_reader :email, :password, :request

      def remove_existing_sessions(user)
        user.refresh_tokens.delete_all
      end

      def create_refresh_token(user, refresh_token, jti)
        user.refresh_tokens.create!(refresh_token_attributes(refresh_token, jti))
      end

      def refresh_token_attributes(refresh_token, jti)
        {
          token_digest: Digest::SHA256.hexdigest(refresh_token),
          expires_at: refresh_token_expires_in.from_now,
          jti: jti,
          ip_address: request&.remote_ip,
          user_agent: request&.user_agent,
        }
      end
    end
  end
end
