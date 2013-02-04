require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# load up roles
 
# require acting_role first, because other roles are depending on it
require "./lib/authorization/acting_role" 
roles_path = File.expand_path("../../lib/authorization", __FILE__)
Dir.glob(File.join(roles_path, "**", "*rb")).each { |f| require f }
