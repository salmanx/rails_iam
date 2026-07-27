# frozen_string_literal: true

module RailsIam
  class Configuration
    attr_reader :authorization, :jwt, :authentication

    attr_accessor :user_class, :current_user_method, :audit_performer_method

    def initialize
      # Each concern has its own configuration object to keep the
      @authorization = RailsIam::Config::Authorization.new
      @jwt = RailsIam::Config::Jwt.new
      @authentication = RailsIam::Config::Authentication.new

      # Host Application User Model, defaults to RailsIam::User
      # Used throughout RailsIam for authentication, authorization associations, and user lookup.
      @user_class = "RailsIam::User"

      # Current User Resolver, defaults to current_user
      # Method used by RailsIam to obtain the authenticated user when
      # the host application already manages authentication (e.g. Devise,)
      @current_user_method = :current_user

      # Audit performer method
      # Used to audit who created/assigned what permission
      # support symbol both symbol and proc i,e ->(user) { "#{user.id}:#{user.username}" }
      @audit_performer_method = :email
    end
  end
end
