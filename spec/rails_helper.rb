require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

# Require the dummy app's environment file
require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'

require "./spec/support/test_helper"

# Dir[Rails.root.join('spec/support/**/*.rb')].sort.each do |f|
#   require f
# end

FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods

  config.include TestHelper


end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end