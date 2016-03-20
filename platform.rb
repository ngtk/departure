# Departure Platform
# ------------------
# Rails 4 application template
#

# overwriting the source_paths method to contain
# current path includes templates.
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

#
# Testing
#
gem_group :test, :development do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

remove_dir 'test'

application do
  <<-APP
    config.generators do |g|
      g.test_framework :rspec, view_specs: false, fixture: true
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  APP
end

after_bundle do
  generate 'rspec:install'
  remove_file 'spec/rails_helper.rb'
  copy_file   'spec/rails_helper.rb'
end
