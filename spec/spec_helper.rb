ENV["RAILS_ENV"] = "test"
require "database_cleaner"
require "bundler/setup"
require "scenic"
require "scenic_sqlite_adapter"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:",
  verbosity: "quiet"
)

RSpec.configure do |config|
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  DatabaseCleaner.strategy = :transaction

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
