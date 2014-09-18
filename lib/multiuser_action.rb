class MultiuserAction < Trello::Action

  # class for search request in multiuser configuration

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def client
    @client ||= Trello::Client.new(
      consumer_key:       ENV['CONSUMER_KEY'],
      consumer_secret:    ENV['CONSUMER_SECRET'],
      oauth_token:        user.oauth_token,
      oauth_token_secret: user.oauth_token_secret )
  end

  def search(query, opts={})
    response = client.get("/search/", { query: query }.merge(opts))
    formatted_response = JSON.parse(response).except("options").inject({}) do |res, key|
      res.merge!({ key.first => key.last.jsoned_into("Trello::#{key.first.singularize.capitalize}".constantize) })
      res
    end
  end

end
