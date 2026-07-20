# frozen_string_literal: true

module RailsIam
  class RailsIamService < ApplicationService
    def self.call(...)
      new(...).call
    end

    def user_class
      RailsIam.configuration.user_class.constantize
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
