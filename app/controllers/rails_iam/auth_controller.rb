# frozen_string_literal: true

module RailsIam
  class AuthController < ApplicationController
    include ActionController::Cookies
    include RailsIam::AuthConcern
    include RailsIam::ConfigLoader

    rescue_from RailsIam::Authentication::Exceptions::AuthenticationError, with: :render_auth_error

    def sign_in
      result = RailsIam::Authentication::Login.call(
        email: login_params[:email],
        password: login_params[:password],
        request: request,
      )

      ensure_valid_strategy!

      create_authenticated_user_cookies!(result) if strategy_includes?(:cookie)

      if strategy_includes?(:bearer)
        render json: token_response_payload(result)
      else
        render json: { user: result.user }
      end
    end

    def sign_out
      refresh_token = current_refresh_token

      RailsIam::Authentication::Logout.call(
        refresh_token: refresh_token,
      )

      delete_authenticated_user_cookies! if strategy_includes?(:cookie)

      head :no_content
    end

    def refresh
      refresh_token = current_refresh_token

      validate_refresh_token(refresh_token)

      user = refresh_token.user
      jti = SecureRandom.uuid

      new_access_token = RailsIam::Authentication::JwtEncoder.call(user, jti: jti)

      cookies.encrypted[access_token_key] = {
        value: new_access_token,
        expires: access_token_expires_in,
        **cookie_options,
      }

      refresh_token.update!(last_used_at: Time.current, jti: jti)

      render json: { success: true }
    end

    private

    def create_authenticated_user_cookies!(result)
      cookies.encrypted[access_token_key] = {
        value: result.access_token,
        expires: result.access_token_expires_in,
        **cookie_options,
      }

      cookies.encrypted[refresh_token_key] = {
        value: result.refresh_token,
        expires: result.refresh_token_expires_in,
        **cookie_options,
      }
    end

    def delete_authenticated_user_cookies!
      cookies.delete(access_token_key)
      cookies.delete(refresh_token_key)
    end

    def validate_refresh_token(refresh_token)
      return unless refresh_token.nil? || refresh_token.revoked_at.present? || refresh_token.expires_at < Time.current

      raise RailsIam::Authentication::Exceptions::AuthenticationError, token_error
    end

    def ensure_valid_strategy!
      return unless (authentication_strategies & %i[cookie bearer]).empty?

      raise RailsIam::Authentication::Exceptions::AuthenticationError, authentication_strategy_error
    end

    def strategy_includes?(strategy)
      authentication_strategies.include?(strategy)
    end

    def token_response_payload(result)
      {
        user: result.user,
        access_token: result.access_token,
        refresh_token: result.refresh_token,
        access_token_expires_in: result.access_token_expires_in,
        refresh_token_expires_in: result.refresh_token_expires_in,
      }
    end

    def login_params
      params.expect(auth: %i[email password])
    end
  end
end
