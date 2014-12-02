require "bundler/setup"
require "m2config" # rspec automatically adds ./lib to LOAD_PATH
require "sqlite3"
require "pp"
require "pry"
require "pry-nav"

DEFAULT_DB_NAME = "config.sqlite"
CUSTOM_DB_NAME = "custom.sqlite"
EXISTING_DB_NAME = "empty.sqlite"

RSpec.configure do |config|
  File.delete DEFAULT_DB_NAME rescue nil
  CFG = M2Config::Config.new(DEFAULT_DB_NAME,{ignoreDoubles:true})
  config.around(:each) do |example|
    CFG.db.transaction do
      example.call
      raise Sequel::Error::Rollback
    end
  end
end
