require 'serverspec'
set :backend, :exec

describe "rails new APP -m departure/platform.rb" do
  subject { system("rails new #{app_name} -m #{template_path}") }

  before do
    system("rm -rf #{app_path}") if Dir.exist?(app_path)
  end

  let(:dir_path) { File.expand_path(File.dirname(__FILE__)) }
  let(:template_path) { "#{dir_path}/platform.rb" }
  let(:app_name) { "tmp/awesome_app" }
  let(:app_path) { "#{dir_path}/#{app_name}" }

  let(:gemfile) { file(app_path + '/Gemfile') }
  let(:application_rb) do
    file(app_path + "/config/application.rb")
  end
  let(:application_js) do
    file(app_path + "/app/assets/javascripts/application.js")
  end
  let(:application_scss) do
    file(app_path + "/app/assets/stylesheets/application.scss")
  end
  let(:application_css) do
    file(app_path + "/app/assets/stylesheets/application.css")
  end

  let(:gems) do
    %w(
    aasm
    cancancan
    config
    default_value_for
    delayed_job_active_record
    devise
    draper
    kaminari
    paper_trail
    paperclip
    puma
    semantic-ui-sass
    simple_form
    squeel
    )
  end

  let(:test_development_group_gems) do
    %w(
    annotate
    awesome_print
    better_errors
    binding_of_caller
    capybara
    capybara-screenshot
    capybara-webkit
    factory_girl_rails
    hirb
    hirb-unicode
    pry-rails
    quiet_assets
    rspec-rails
    rubocop
    scss_lint
    shoulda-matchers
    spring-commands-rspec
    timecop
    )
  end


  it "installed sccessfully", aggregate_failures: true do
    expect { subject }.to output(/installed successfully! Yay!/).to_stdout_from_any_process

    gems.each do |gem|
      expect(gemfile).to contain(gem)
    end

    test_development_group_gems.each do |gem|
      expect(gemfile).to contain(gem)
        .after(/^group :test, :development do/)
    end

    expect(application_rb).to contain("g.test_framework :rspec, view_specs: false, fixture: true")
      .from(/config\.generators do \|g\|/)
      .to(/end/)
    expect(application_rb).to contain("g.fixture_replacement :factory_girl, dir: \"spec/factories\"")
      .from(/config\.generators do \|g\|/)
      .to(/end/)
    expect(application_rb).to contain("config.active_job.queue_adapter = :delayed_job")

    expect(application_js).to contain "//= require semantic-ui"
    expect(application_scss).to contain '@import "semantic-ui";'
    expect(application_css).not_to exist
  end
end
