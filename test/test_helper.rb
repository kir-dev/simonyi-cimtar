require 'rubygems'
require 'spork'
require 'test/unit'
require 'mocha/setup'
require 'factory_girl'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

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

    # creates a user with the given factory, and creates an
    # ability for the user
    def create_user_and_ability(factory)
      user = FactoryGirl.create factory
      ability = Ability.new user

      return user, ability
    end
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

  # load factories
  FactoryGirl.factories.clear
  FactoryGirl.find_definitions

end
