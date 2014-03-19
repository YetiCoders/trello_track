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

      @members = [ trello_user, TrelloSpecHelper.member, TrelloSpecHelper.member, TrelloSpecHelper.member ]
      TrelloSpecHelper.stub_find(@members)

      @organizations = [ TrelloSpecHelper.organization, TrelloSpecHelper.organization ]
      trello_user.stub(:organizations).and_return(@organizations)
      @organizations[0].stub(:members).and_return([ trello_user, @members[1], @members[2] ])
      @organizations[1].stub(:members).and_return([ trello_user, @members[3] ])

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
      expect(assigns[:members]).to eq(
        {
          @organizations[0].id => [ @members[0], @members[1], @members[2] ],
          @organizations[1].id => [ @members[0], @members[3] ]
        }
      )
    end
  end
end
