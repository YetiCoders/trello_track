class SessionsController < ApplicationController
  skip_before_filter :authenticate

  def create
    begin
      _client.find(:member, 'me')
    rescue NoMethodError
      return
    end
  end

  def auth
    rt = session[:request_token]
    at = rt.get_access_token oauth_verifier: params[:oauth_verifier]
    _client.auth_policy.token = Trello::Authorization::OAuthCredential.new at.token, nil

    member = _client.find(:member, 'me')
    user = User.find_or_initialize_by(uid: member.id)
    user.name = member.username
    user.oauth_token = at.params[:oauth_token]
    user.oauth_token_secret = at.params[:oauth_token_secret]
    user.time_zone = Time.zone.name

    if user.save
      session[:user_id] = user.id
      session[:token] = user.oauth_token
    end

    # re-validate cache on sign_in
    fetch_member(member.id, true)

    redirect_to root_url
  end

  def destroy
    reset_session
    cookies.delete "browser.timezone"
    redirect_to root_url
  end

  private

  def _client
    @client ||= Trello::Client.new(
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      return_url: oauth_callback_url,
      callback: lambda {|request_token|
        session[:request_token] = request_token
        redirect_to "#{request_token.authorize_url}&name=TrelloTrack&expiration=never"
      }
    )
  end
end
