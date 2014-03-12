class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :trello_client, :trello_user, :system_user
  before_filter :authenticate

  include ApplicationHelper

  private

  def trello_user
    @trello_user ||= trello_client.find(:member, 'me')
  end

  def trello_client
    @trello_client ||= Trello::Client.new(
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      oauth_token: system_user.oauth_token,
      oauth_token_secret: system_user.oauth_token_secret)
  end

  def system_user
    @system_user ||= User.where(id: session[:user_id], oauth_token: session[:token]).try(:first)
  end

  def authenticate
    redirect_to root_url unless system_user
  end
end
