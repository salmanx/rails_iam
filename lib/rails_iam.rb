# frozen_string_literal: true

require "rails_iam/version"
require "rails_iam/engine"

require "rails_iam/configuration/configuration"

module RailsIam
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
