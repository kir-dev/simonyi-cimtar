require 'rubygems'
require 'spork'
require 'test/unit'
require 'mocha/setup'
require 'factory_girl'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

module ManagedObservers
  def with_observer(*observers)
    ActiveRecord::Base.observers.enable(*observers)
    yield
    ActiveRecord::Base.observers.disable(:all)
  end

  alias_method :with_observers, :with_observer
end

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting

    include ManagedObservers

    # Add more helper methods to be used by all tests here...

    # some syntactic sugar when expecting a false value
    def assert_not(a, *args)
      assert !a, *args
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
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # in prefork block it will load models and then spork with
  # pick up changes to them
  ActiveSupport::TestCase.fixtures :all

  # disable all observers for speeding up test and to test observers in isolation
  ActiveRecord::Base.observers.disable(:all)

  # load factories
  FactoryGirl.reload

  # reloading role files every time to pick up changes
  lib_path = File.expand_path "../../lib", __FILE__
  require File.join(lib_path, "roles")
end
