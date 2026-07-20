# frozen_string_literal: true

module RailsIam
  class RailsIamService < ApplicationService
    def self.call(...)
      new(...).call
    end

    def user_class
      RailsIam.configuration.user_class.constantize
    end

    def access_token_key
      RailsIam.configuration.authentication.access_token_key
    end

    def refresh_token_key
      RailsIam.configuration.authentication.refresh_token_key
    end

    def access_token_expires_in
      RailsIam.configuration.authentication.access_token_expires_in.from_now
    end

    def refresh_token_expires_in
      RailsIam.configuration.authentication.refresh_token_expires_in.from_now
    end

    def session_strategy
      RailsIam.configuration.authentication.session_strategy&.to_sym
    end

    def jwt_secret_key
      RailsIam.configuration.jwt.secret
    end

    def jwt_algorithm
      RailsIam.configuration.jwt.algorithm || "HS256"
    end

    def jwt_expiry
      RailsIam.configuration.jwt.jwt_expires_in.from_now.to_i
    end
  end
end
