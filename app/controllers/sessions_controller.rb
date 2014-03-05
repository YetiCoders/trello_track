class SessionsController < ApplicationController
  def create
    if session[:client].nil?
      session[:client] = Trello::Client.new(
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        return_url: oauth_callback_url,
        callback: lambda {|request_token|
          session[:request_token] = request_token
          Rails.logger.debug('-' * 100)
          Rails.logger.debug(request_token.inspect)
          redirect_to "#{request_token.authorize_url}&name=TrelloTrack&expiration=never"
        }
      )
    end

    me = session[:client].find(:member, 'me')
    #Rails.logger.debug(session[:client].inspect)

    redirect_to root_url
  end

  def auth
    rt = session[:request_token]
    Rails.logger.debug('=' * 100)
    Rails.logger.debug(rt.inspect)

    at = rt.get_access_token :oauth_verifier => params[:oauth_verifier]
    session[:client].auth_policy.token = Trello::Authorization::OAuthCredential.new at.token, nil

    redirect_to root_url #URI::decode(params[:return])
  end

  def destroy
    session[:client] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
