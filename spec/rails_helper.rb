ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/webkit'
require 'capybara-screenshot/rspec'
require 'shoulda/matchers'

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit
Capybara.default_host = "http://localhost:8080"
Capybara.asset_host = 'http://localhost:8080'
Capybara.default_max_wait_time = 10
Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.skip_image_loading
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryGirl::Syntax::Methods
end
