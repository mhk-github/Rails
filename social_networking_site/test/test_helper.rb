ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors, with: :threads)

  # MHK
  # Add a callback that runs before TestCase::setup to seed the test database
  setup do
#    Rails.application.load_seed
  end

end
