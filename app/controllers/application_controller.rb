class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :trello_user, :system_user
  before_filter :check_trello_user

  private

  def trello_user
    if !@trello_user && session[:user_id]
      user = User.where(id: session[:user_id], oauth_token: session[:token]).first
      if user
        @trello_user = Trello::Client.new(
          consumer_key: ENV['CONSUMER_KEY'],
          consumer_secret: ENV['CONSUMER_SECRET'],
          oauth_token: user.oauth_token,
          oauth_token_secret: user.oauth_token_secret
        ).find(:member, 'me')
      end
    end

    @trello_user
  end

  def system_user
    @system_user ||= User.where(uid: trello_user.id).first
  end

  def check_trello_user
    redirect_to root_url unless trello_user
  end
end
