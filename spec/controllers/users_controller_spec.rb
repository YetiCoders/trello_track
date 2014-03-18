require 'spec_helper'

describe UsersController do
  context "without login" do
    it "show" do
      get :show
      response.should redirect_to root_url
    end

    it "update" do
      post :update
      response.should redirect_to root_url
    end
  end

  context "with login" do
    before(:each) do
      @user = create(:user)
      trello_user = TrelloSpecHelper.member(@user)
      ApplicationController.any_instance.stub(:trello_user).and_return(trello_user)

      login(@user)
    end

    it "show" do
      get :show
      response.should be_success
    end

    it "update - success" do
      post :update, { user: { email: "janev@example.com", subscribed: "1" } }
      response.should be_success
      @user.reload
      expect(@user.email).to eq("janev@example.com")
      expect(@user.subscribed).to be_true
      expect(flash[:error]).to be_nil
      expect(flash[:success]).not_to be_empty

      post :update, {user: { email: "", subscribed: "0"}}
      response.should be_success
      @user.reload
      expect(@user.email).to eq("")
      expect(@user.subscribed).to be_false
      expect(flash[:error]).to be_nil
      expect(flash[:success]).not_to be_empty
    end

    it "update - error" do
      post :update, { user: { email: "", subscribed: "1" } }
      response.should be_success

      @user.reload
      expect(@user.email).not_to be_empty
      expect(@user.subscribed).to be_false
      expect(flash[:success]).to be_nil
      expect(flash[:error]).not_to be_empty
    end
  end
end
