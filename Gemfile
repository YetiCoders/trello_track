source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '~> 4.0.2'
gem 'pg'

gem 'bootstrap-sass'
gem 'bootstrap-switch-rails'
gem 'browser-timezone-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'dalli'
gem 'exception_notification'
gem 'exception_notification-rake', '~> 0.1.2'
gem 'font-awesome-sass'
gem 'foreman'
gem 'jquery-rails'
gem 'haml'
gem 'hpricot'  # need for premailer-rails
gem 'premailer-rails'
gem 'puma'
gem 'ruby-trello', github: 'jeremytregunna/ruby-trello'
gem 'sass-rails', '~> 4.0.0'
gem 'sprockets', '2.11.0'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'

# enable heroku features
group :production do
  gem 'rails_12factor'
  gem 'memcachier'
end

group :development, :test do
  # Use dotenv for load secrets
  gem 'dotenv-rails'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

gem 'simplecov', :require => false, :group => :test
gem "codeclimate-test-reporter", group: :test, require: nil
