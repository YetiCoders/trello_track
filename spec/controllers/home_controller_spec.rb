require 'spec_helper'

describe HomeController do
  context "without login" do
    it "index" do
      get :index
      response.should be_success
    end
  end

  context "with login" do
    before(:each) do
      user = create(:user)
      trello_user = TrelloSpecHelper.member(user)
      ApplicationController.any_instance.stub(:trello_user).and_return(trello_user)
      @organizations = [ TrelloSpecHelper.organization, TrelloSpecHelper.organization ]
      trello_user.stub(:organizations).and_return(@organizations)
      @organizations[0].stub(:members).and_return([ trello_user, TrelloSpecHelper.member, TrelloSpecHelper.member ])
      @organizations[1].stub(:members).and_return([ trello_user, TrelloSpecHelper.member ])

      login(user)
    end

    it "index with login" do
      get :index
      response.should redirect_to main_url
    end

    it "main" do
      get :main
      response.should be_success

      expect(assigns[:organizations]).to match_array(@organizations)
      expect(assigns[:members].values.flatten.size).to eq(5)
    end
  end
end
