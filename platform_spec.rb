describe "rails new APP -m departure/platform.rb" do
  subject { system("rails new #{app_name} -m #{template_path}") }

  let(:dir_path) { File.expand_path(File.dirname(__FILE__)) }
  let(:template_path) { "#{dir_path}/platform.rb" }
  let(:app_name) { "tmp/awesome_app" }
  let(:app_path) { "#{dir_path}/#{app_name}" }

  before do
    system("rm -rf #{app_path}") if Dir.exist?(app_path)
  end

  it { expect { subject }.to output(/installed successfully! Yay!/).to_stdout_from_any_process }
end
