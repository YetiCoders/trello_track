class TrelloWrapper
  def self.trello_client(system_user)
    Trello::Client.new(
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      oauth_token: system_user.oauth_token,
      oauth_token_secret: system_user.oauth_token_secret
    )
  end
end