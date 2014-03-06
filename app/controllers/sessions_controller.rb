class SessionsController < ApplicationController

  def create
    begin
      me = get_client.find(:member, 'me')
    rescue NoMethodError
      return
    end

    redirect_to root_url
  end

  def auth
    rt = session[:request_token]

    at = rt.get_access_token :oauth_verifier => params[:oauth_verifier]
    get_client.auth_policy.token = Trello::Authorization::OAuthCredential.new at.token, nil

    redirect_to root_url #URI::decode(params[:return])
  end

  def destroy
    session[:client] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  private

  def get_client
    Trello::Client.new(
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
