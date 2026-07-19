# frozen_string_literal: true

module RailsIam
  class RailsIamService < ApplicationService
    def self.call(...)
      new(...).call
    end

    def user_class
      RailsIam.configuration.user_class.constantize
    end
  end
end
