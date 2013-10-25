# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load the app's custom environment variables here, before environments/*.rb
CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]

# Initialize the Rails application.
HackappNew::Application.initialize!
