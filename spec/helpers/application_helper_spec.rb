require 'spec_helper'

describe ApplicationHelper do
  describe "flash_html" do
    it "flash_html - empty flash messages" do
      expect(helper.flash_html).to eq("")
    end

    it "flash_html - error" do
      flash[:error] = "Error"
      expect(helper.flash_html).to eq("<div class=\"alert alert-dismissable alert-danger\"><div aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\">&times;</div>Error</div>")
    end

    it "flash_html - success" do
      flash[:success] = "Success"
      expect(helper.flash_html).to eq("<div class=\"alert alert-dismissable alert-success\"><div aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\">&times;</div>Success</div>")
    end
  end

  describe "js_void" do
    it "js_void" do
      expect(helper.js_void).to eq("javascript:void(0);")
    end
  end

  describe "user_avatar" do
    it "user_avatar - avatar exist" do
      member = TrelloSpecHelper.member(create(:user, uid: "aaa"))
      expect(helper.user_avatar(member)).to eq("<img alt=\"30\" src=\"https://trello-avatars.s3.amazonaws.com/aaa/30.png\" />")
    end

    it "user_avatar - avatar not exist" do
      member = TrelloSpecHelper.member(create(:user, uid: nil))
      expect(helper.user_avatar(member)).to eq("<img alt=\"Avatar small\" src=\"/assets/avatar_small.png\" />")
    end
  end
end