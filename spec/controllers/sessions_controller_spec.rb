require 'spec_helper'

describe SessionsController do
  context "create" do
    it "create" do
      get :create
      response.should redirect_to /https:\/\/trello.com\/1\/OAuthAuthorizeToken/
    end
  end

  context "auth" do
    it "auth" do
      trello_user = TrelloSpecHelper.member
      Trello::Client.any_instance.stub(:find).and_return(trello_user)
      SessionsController.any_instance.stub(:fetch_member)

      session[:request_token] = RequestToken.new

      get :auth, { oauth_verifier: SecureRandom.uuid }
      response.should redirect_to root_url

      user = User.last
      expect(user.name).to eq(trello_user.username)
      expect(user.uid).to eq(trello_user.id)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  context "destroy" do
    it "destroy" do
      session[:user_id] = 111
      session[:token] = SecureRandom.uuid
      expect(session).not_to be_empty

      get :destroy
      response.should redirect_to root_url
      expect(session).to be_empty
    end
  end
end
