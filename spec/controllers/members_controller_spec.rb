require 'spec_helper'

describe MembersController do
  before :each do
    @user = create(:user)
    @organization = TrelloSpecHelper.organization
  end

  context "without login" do
    it "show" do
      get :show, id: @user.uid, organization_id: @organization.id
      response.should redirect_to root_url
    end

    it "activities" do
      get :activities, id: @user.uid, organization_id: @organization.id
      response.should redirect_to root_url
    end

    it "cards" do
      get :cards, id: @user.uid, organization_id: @organization.id
      response.should redirect_to root_url
    end

    it "follow" do
      get :follow, id: @user.uid
      response.should redirect_to root_url
    end
  end

  context "with login" do
    before(:each) do
      @trello_user = TrelloSpecHelper.member(@user)
      @organizations = [ @organization, TrelloSpecHelper.organization ]
      @members = [ @trello_user, TrelloSpecHelper.member, TrelloSpecHelper.member ]
      TrelloSpecHelper.stub_find(@members)

      @trello_user.stub(:organizations).and_return(@organizations)
      @organization.stub(:members).and_return(@members)
      mems = @members[0, 2]
      @board = TrelloSpecHelper.board
      @list1 = TrelloSpecHelper.list
      @list2 = TrelloSpecHelper.list
      @card1 = TrelloSpecHelper.card([ mems[0], mems[1] ], @list1, @board)
      @card2 = TrelloSpecHelper.card([ mems[0] ], @list2, @board)
      @organization.stub(:boards).and_return([@board])
      @boards = [ @board ]
      MultiuserAction.any_instance.stub(:search).and_return("cards" => [@card1, @card2])

      login(@user)
    end

    it "show" do
      get :show, id: @user.uid, organization_id: @organization.id
      response.should be_success
      expect(assigns[:tab_members]).to match_array(@members)
      expect(assigns[:current_member]).to eq(@trello_user)
    end

    it "show - xhr" do
      xhr :get, :show, id: @user.uid, organization_id: @organization.id
      response.should be_success
    end

    it "show - organization is wrong" do
      get :show, id: @user.uid, organization_id: 'aaa'
      response.should redirect_to main_url
    end

    it "show - member is wrong" do
      get :show, id: 'bbb', organization_id: @organization.id
      response.should redirect_to main_url
    end

    it "cards" do
      @card1.stub(:board).and_return(@board)
      @card1.stub(:list).and_return(@list1)
      @card2.stub(:board).and_return(@board)
      @card2.stub(:list).and_return(@list2)

      xhr :get, :cards, id: @user.uid, organization_id: @organization.id
      response.should be_success
      expect(assigns[:cards]).to match_array([ @card1, @card2 ])
      expect(assigns[:ids]).to eq({ @board.id => @board, @list1.id => @list1, @list2.id => @list2 })
    end

    it "activities" do
      action1 = TrelloSpecHelper.action(@trello_user)
      action2 = TrelloSpecHelper.action(@trello_user, "addMemberToBoard")
      @trello_user.stub(:actions).and_return( [ action1, action2 ])

      xhr :get, :activities, id: @user.uid, organization_id: @organization.id
      response.should be_success
      expect(assigns[:actions]).to match_array([ action1, action2 ])
    end
  end

  context "following" do
    before(:each) do
      @trello_user = TrelloSpecHelper.member(@user)
      ApplicationController.any_instance.stub(:trello_user).and_return(@trello_user)
      login(@user)
    end

    it "follow - add" do
      post :follow, id: "aaa", follow: "aaa"
      response.should be_success
      @user.reload
      expect(@user.followers).to match_array(['aaa'])

      post :follow, id: "bbb", follow: "bbb"
      response.should be_success
      @user.reload
      expect(@user.followers).to match_array(['aaa', 'bbb'])
    end

    it "follow - remove" do
      @user.followers = ['aaa', 'bbb']
      expect(@user.followers).to match_array(['aaa', 'bbb'])

      post :follow, id: "aaa"
      response.should be_success
      @user.reload
      expect(@user.followers).to match_array(['bbb'])

      post :follow, id: "ccc"
      response.should be_success
      @user.reload
      expect(@user.followers).to match_array(['bbb'])

      post :follow, id: "bbb"
      response.should be_success
      @user.reload
      expect(@user.followers).to match_array([])
    end
  end
end
