# frozen_string_literal: true

module RailsIam
  class Engine < ::Rails::Engine
    isolate_namespace RailsIam

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
    end
  end
end
