$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'audiomator'

def fixture_path
  @fixture_path ||= File.join(File.dirname(__FILE__), 'fixtures')
end
