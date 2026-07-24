# frozen_string_literal: true

require "rails_iam/version"

require "rails_iam/configuration"
require "rails_iam/config/authorization"
require "rails_iam/config/jwt"
require "rails_iam/config/authentication"

require "rails_iam/controller_dsl"
require "rails_iam/model_dsl"

# keep  engine require at bottom
require "rails_iam/engine"
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
