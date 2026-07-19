# frozen_string_literal: true

module RailsIam
  class Configuration
    attr_reader :authorization

    attr_accessor :user_class,
                  :current_user_method

    def initialize
      # Each concern has its own configuration object to keep the
      @authorization = RailsIam::Config::Authorization.new

      # Host Application User Model, defaults to RailsIam::User
      # Used throughout RailsIam for authentication, authorization associations, and user lookup.
      @user_class = "RailsIam::User"

      # Current User Resolver, defaults to current_user
      # Method used by RailsIam to obtain the authenticated user when
      # the host application already manages authentication (e.g. Devise,)
      @current_user_method = :current_user
    end
  end
end
