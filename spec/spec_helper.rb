$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'rspec/autorun'

Rspec.configure do |c|
  c.mock_with :rspec
end

require 'soundcloud'

def fake_track(track)
  JSON.parse File.open("spec/support/#{track}.json").read.to_s
end