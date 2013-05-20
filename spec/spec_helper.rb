require 'rspec'
require 'webmock/rspec'
require 'rumba/crawler'


RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = :documentation
end