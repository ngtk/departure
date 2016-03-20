# Departure Platform
# ------------------
# Rails 4 application template
#

# overwriting the source_paths method to contain
# current path includes templates.
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# fix multiple line indent issue
require 'active_support/core_ext/string' # using String#indent
# Rails::Generators::Actions#environment
# ref: https://github.com/rails/rails/blob/v4.2.6/railties/lib/rails/generators/actions.rb#L87-L102
def environment(data=nil, options={})
  sentinel = /class [a-z_:]+ < Rails::Application/i
  env_file_sentinel = /Rails\.application\.configure do/
  data = yield if !data && block_given?

  in_root do
    if options[:env].nil?
      inject_into_file 'config/application.rb', "\n#{data.indent(4)}", after: sentinel, verbose: false
    else
      Array(options[:env]).each do |env|
        inject_into_file "config/environments/#{env}.rb", "\n#{data.indent(2)}", after: env_file_sentinel, verbose: false
      end
    end
  end
end
alias :application :environment

# replace path/to/artifact/target with path/to/departure/target
def replace_file(target)
  remove_file(target)
  create_file(target)
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
  gem "spring-commands-rspec"
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

remove_dir 'test'

application <<-APP
config.generators do |g|
  g.test_framework :rspec, view_specs: false, fixture: true
  g.fixture_replacement :factory_girl, dir: "spec/factories"
end
APP

after_bundle do
  # fix rspec:install stuck issue
  # ref: https://github.com/rspec/rspec-rails/issues/996
  run './bin/spring stop'
  generate 'rspec:install'
  replace_file 'spec/rails_helper.rb'
end

#
# Debug
#
gem_group :test, :development do
  gem 'annotate'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-rails'
  gem 'quiet_assets'
end

after_bundle do
  generate 'annotate:install'
end

#
# Lint
#
gem_group :test, :development do
  gem 'rubocop', require: false
  gem 'scss_lint', require: false
end
