require 'trello'
#Trello.configure do |config|
  #config.consumer_key    = ENV['CONSUMER_KEY']
  #config.consumer_secret = ENV['CONSUMER_SECRET']
  #config.return_url      = "/oauth_callback"
  #config.callback        = lambda { |request_token|
  #  #session[:request_token] = request_token
  #  Rails.logger.debug('-' * 100)
  #  Rails.logger.debug(request_token.inspect)
  #  #redirect_to "#{request_token.authorize_url}&expiration=never"
  #}
#end