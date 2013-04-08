require 'rubygems'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter "/\.bundle/"
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Capybara.javascript_driver = :selenium
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 3

# turn on omniauth test mode
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Features::SessionHelpers, type: :feature
  config.include Features::HeadlessHelpers, type: :feature
  config.include Features::OmniauthHelpers

  # can use this to instrument factory creation
  # config.before(:suite) do
  #   ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
  #     factory_name = payload[:name]
  #     puts "Creating factory: #{factory_name}..."
  #   end
  # end

  # keep database clean before tests
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/test_seeds.rb"
    Features::SessionHelpers.create_test_user
    Features::SessionHelpers.create_test_user_with_list
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
