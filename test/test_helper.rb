ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all  # Comment this out

  # Clean database before each test
  def setup
    super
    DatabaseCleaner.clean_with(:truncation) if defined?(DatabaseCleaner)
    Admin.delete_all
    Volunteer.delete_all
  end
end