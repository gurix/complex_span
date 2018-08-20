require 'simplecov'
SimpleCov.start 'rails'

require 'mongoid-rspec'
require 'capybara/rspec'
require 'factory_girl'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Mongoid::Matchers, type: :model

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.before(:suite) do
    FactoryGirl.reload
    Mongoid.purge!
  end

  config.before(:each) do
    I18n.locale = :en
    ActionMailer::Base.deliveries.clear
    Mongoid.purge!
  end

  Capybara.default_wait_time = 20

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
end
