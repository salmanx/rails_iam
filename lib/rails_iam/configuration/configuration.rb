# frozen_string_literal: true

module RailsIam
  class Configuration
    attr_accessor :user_class

    def initialize
      # Default to RailsIam::User otherwise, use host application user(auth) model
      # Used throughout RailsIam for authentication, authorization associations, and user lookup.
      @user_class = "RailsIam::User"
    end
  end
end
