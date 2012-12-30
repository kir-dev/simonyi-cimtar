ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# load factories
FactoryGirl.find_definitions

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # some syntactic sugar when expecting a false value
  def assert_not(a)
    assert !a
  end

  MAPPING = {
    login: 'HTTP_UID',
    email: 'HTTP_EMAIL',
    full_name: 'HTTP_COMMON_NAME',
    nick: 'HTTP_NICKNAME',
    entitlement: 'HTTP_EDUPERSONENTITLEMENT'
  }

  def set_sso_request_values(request, opts = {})
    opts.each do |k, v|
      request.env[MAPPING[k]] = v
    end
  end
end
