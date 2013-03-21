require "bundler/setup"
require "m2config" # rspec automatically adds ./lib to LOAD_PATH
require "sqlite3"
require "pp"

DEFAULT_DB_NAME = "config.sqlite"
CUSTOM_DB_NAME = "custom.sqlite"
EXISTING_DB_NAME = "empty.sqlite"
