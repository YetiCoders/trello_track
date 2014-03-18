require 'spec_helper'

describe User do
  subject(:user) { create(:user) }

  context "associations" do
    it{ should have_one(:follower) }
  end

  context "validations" do
    it {
      should_not validate_presence_of(:email)

      user.subscribed = true
      should validate_presence_of(:email)
    }
    it "validate email" do
      should_not allow_value('jane').for(:email)
      should allow_value('jane@mail.ru').for(:email)
      should allow_value('').for(:email)
      should allow_value(nil).for(:email)
    end
  end

  context "followers" do
    it "set, get" do
      expect(user.followers).to eq([])

      user.followers = ['aaa', 'bbb']
      expect(User.find(user.id).followers).to eq(['aaa', 'bbb'])
    end
  end
end
