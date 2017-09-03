ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help' # test/test_helper.rb.
require 'minitest/autorun'
require 'capybara/rails'

class ActionDispatch::IntegrationTest  
  # Notice the 'js: true' option.
  class << self
    def test(name, options={}, &block)
      super name do
        Capybara.current_driver = Capybara.javascript_driver if options[:js]
        begin
          self.instance_eval &block
        ensure
          Capybara.use_default_driver if options[:js]
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  
end
