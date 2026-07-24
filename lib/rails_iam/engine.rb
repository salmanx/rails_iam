# frozen_string_literal: true

module RailsIam
  class Engine < ::Rails::Engine
    isolate_namespace RailsIam

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
    end

    initializer "rails_iam.controller_dsl" do
      ActiveSupport.on_load(:action_controller_base) do
        include RailsIam::ControllerDsl
      end

      ActiveSupport.on_load(:action_controller_api) do
        include RailsIam::ControllerDsl
      end
    end

    initializer "rails_iam.model_dsl" do
      ActiveSupport.on_load(:active_record) do
        include RailsIam::ModelDsl
      end
    end
  end
end
