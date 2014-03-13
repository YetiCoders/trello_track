source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.2'
gem 'pg'

gem 'bootstrap-sass'
gem 'browser-timezone-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'dalli'
gem 'exception_notification'
gem 'font-awesome-sass'
gem 'foreman'
gem 'jquery-rails'
gem 'haml'
gem 'hpricot'  # need for premailer-rails
gem 'premailer-rails'
gem 'puma'
gem 'ruby-trello', github: 'yeticoders/ruby-trello', branch: 'trello-track'
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
end
