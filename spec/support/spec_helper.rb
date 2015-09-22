require 'selenium-webdriver'
require 'rspec'
require 'rspec-rerun/tasks'
require 'allure-rspec'
require 'pathname'
require 'uuid'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'allure-rspec'
require 'parallel_tests'
require 'pry'
require_relative 'site'
require_relative '../../lib/pages/login_page'
require_relative '../../lib/pages/home_page'

RSpec.configure do |config|
  config.include AllureRSpec::Adaptor
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) do
    @driver = Capybara.current_session.driver
    @site = Site.new(@driver)
    case ENV['DRIVER']
      when 'poltergeist'
        @driver.clear_cookies
      else
        @driver.browser.manage.delete_all_cookies
    end
  end
  config.after(:all) { @driver.quit unless @driver.nil? }
end

AllureRSpec.configure do |c|
  c.output_dir = "log/screenshots"
  c.clean_dir = false
end

ParallelTests.first_process? ? FileUtils.rm_rf(AllureRSpec::Config.output_dir) : sleep(1)


Capybara.configure do |config|
  config.run_server = false
  config.default_driver = ENV['DRIVER'].to_sym
  config.javascript_driver = config.default_driver
  config.default_selector = :css
  config.default_max_wait_time = 6
  config.app_host = 'https://wordpress.com'
end

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  Capybara::Selenium::Driver.new(app, :profile => profile)
end

Capybara.register_driver :chrome do |app|
  Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, 'vendor/chromedriver_mac')
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :poltergeist do |app|
  options = {
      :js_errors => true,
      :timeout => 120,
      :debug => false,
      :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
      :inspector => true,
  }
  Capybara::Poltergeist::Driver.new(app, options)
end


