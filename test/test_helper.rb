ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/test/"
  add_filter "/app/policies/application_policy.rb"
  add_filter "/lib/clarat_base/"
  minimum_coverage 100
end

# test requires

require 'minitest' # Testing using Minitest
require 'minitest-matchers'
# require 'minitest-line'
require 'minitest-rails-capybara'
require 'launchy' # save_and_open_page
require 'mocha'
require 'factory_girl_rails'
require 'ffaker'
require 'memory_test_fix' # Sqlite inmemory fix
require 'rake'
require 'database_cleaner'
require 'timecop'

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'minitest/pride'
require 'mocha/mini_test'
require 'capybara/rails'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'minitest/hell'
require 'pry-rescue/minitest' if ENV['RESCUE']
require 'pry'
require 'sidekiq/testing'
require 'fakeredis/minitest'
require 'shoulda-matchers'
require 'shoulda/matchers'

# For Sidekiq

Sidekiq::Testing.inline!

# Inclusions: First matchers, then modules, then helpers.
# Helpers need to be included after modules due to interdependencies.
Dir[File.expand_path('../../test/support/modules/*.rb', __FILE__)]
  .each { |f| require f }
Dir[File.expand_path('../../test/support/spec_helpers/*.rb', __FILE__)]
  .each { |f| require f }
Dir[File.expand_path('../../test/factories/*.rb', __FILE__)]
  .each { |f| require f }
# require additional folders?
Dir[Rails.root.join('test/workers/*.rb')].each { |f| require f }
Dir[Rails.root.join('test/mailers/*.rb')].each { |f| require f }

# Redis
Redis.current = Redis.new
Capybara.asset_host = 'http://localhost:3000'

# For fixtures:
include ActionDispatch::TestProcess

# ~Disable logging for test performance!
# Change this value if you really need the log and run your suite again~
Rails.logger.level = 4

### Test Setup ###
File.open(Rails.root.join('log/test.log'), 'w') { |f| f.truncate(0) } # clearlog

silence_warnings do
  # BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST # needed?
end

Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Minitest.after_run do
  if $suite_passing
    brakeman
    rails_best_practices
    rubocop
  end
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  self.use_transactional_fixtures = true
  self.fixture_path = ClaratBase::Engine.root.join('test', 'fixtures')
  fixtures :all

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
end

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean

    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
end

# Shoulda::Matchers.configure do |config|
#   config.integrate do |with|
#     # Choose a test framework:
#     with.test_framework :minitest
#     # with.test_framework :minitest_4
#
#     # Choose one or more libraries:
#     with.library :rails
#   end
# end

$suite_passing = true

DatabaseCleaner.strategy = :transaction
