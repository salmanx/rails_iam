# frozen_string_literal: true

module RailsIam
  module AuthConcern
    extend ActiveSupport::Concern

    def extract_refresh_token_from_header
      header_key = "HTTP_#{refresh_token_key.upcase}"

      request.get_header(header_key)
    end

    def extract_refresh_token_from_cookie
      request.cookie_jar.encrypted[refresh_token_key]
    end

    def current_refresh_token
      return unless (refresh_token = extract_refresh_token)

      digest = Digest::SHA256.hexdigest(refresh_token)
      RailsIam::RefreshToken.find_by(token_digest: digest)
    end

    def extract_refresh_token
      return extract_refresh_token_from_cookie if authentication_strategies.include?(:cookie)

      case refresh_token_transport
      when :header
        extract_refresh_token_from_header

      when :request_body
        params[:refresh_token]

      else
        raise RailsIam::Authentication::Exceptions::AuthenticationError, refresh_token_transport_error
      end
    end

    def render_authorization_error(exception)
      render json: {
        message: exception.message,
        code: "forbidden".upcase,
        status: 403,
        url: request.original_fullpath,
      }, status: :forbidden
    end

    def render_authentication_error(exception)
      render json: {
        message: exception.message,
        code: "unauthorized".upcase,
        status: 401,
        url: request.original_fullpath,
      }, status: :unauthorized
    end
  end
end
