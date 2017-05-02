source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 3.2.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '~> 0.15.0'
gem 'unicorn', '~> 4.9.0'
gem 'rainbow'
gem 'mail_form'
gem 'simple_form'
gem 'insightly2', github: 'insightly/insightly-ruby' # Monkey patched Hash to remove RoR4 depencency
gem 'activeadmin'
gem 'devise'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'compass-h5bp'
  gem 'bootstrap-sass'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'html5-rails'
gem 'test-unit' # Heroku complains without it when running console

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
group :development, :test do
  gem 'rspec-rails'
  gem 'byebug'
end

group :development do
  gem 'letter_opener'
end
