# frozen_string_literal: true

module RailsIam
  class RailsIamService < ApplicationService
    include RailsIam::ConfigLoader

    def self.call(...)
      new(...).call
    end
  end
end
