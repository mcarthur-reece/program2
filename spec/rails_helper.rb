# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Near the top of the file, after require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }


# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Add FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Add controller helpers for testing sessions
  config.include Devise::Test::IntegrationHelpers, type: :request if defined?(Devise)

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Add this block to disable CSRF for request specs
  config.before(:each, type: :request) do
    # Disable CSRF token verification in tests
    ActionController::Base.allow_forgery_protection = false
  end

  config.after(:each, type: :request) do
    # Re-enable it after tests (good practice)
    ActionController::Base.allow_forgery_protection = true
  end
end
