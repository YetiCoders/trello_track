class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :current_user, :check_current_user

  private

  def current_user
    if session[:user_id]
      user = User.where(id: session[:user_id], oauth_token: session[:token]).first
      if user
        @current_user ||= Trello::Client.new(
          consumer_key: ENV['CONSUMER_KEY'],
          consumer_secret: ENV['CONSUMER_SECRET'],
          oauth_token: user.oauth_token,
          oauth_token_secret: user.oauth_token_secret
        ).find(:member, 'me')
      end
    end
  end

  def check_current_user
    unless current_user
      redirect_to root_url
    end
  end
end
