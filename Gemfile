source 'https://rubygems.org'

gem 'rails', '3.2.11'

gem 'best_in_place'
gem 'validates_timeliness', '~> 3.0'
gem 'gravtastic'
gem 'nested_form'

group :production do
  gem 'pg'
end

group :development do
  gem 'quiet_assets'
  gem 'webrick', '1.3.1'
end

group :migration do
  gem 'sequel', :require => false

  # apt-get install libldap2-dev libsasl2-dev
  gem 'ruby-ldap', '~> 0.9.12', :require => false
end

group :test do
  gem 'factory_girl', '~> 4.0', :require => false
  # gem 'spork-testunit', :require => false
  gem 'spork-rails', :require => false
  gem 'mocha', :require => false
end

gem 'sqlite3', :group => [ :development, :test ]

if ENV['CI'] != "true"
  gem 'debugger', :group => [ :development, :test ]
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  #gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer', '~> 0.11.0', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '~> 2.1.9'
  gem 'less-rails'
  # gem 'jquery-ui-rails'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
