require 'spec_helper'

describe Follower do
  context "validations" do
    it { should validate_presence_of(:user_id) }
  end
end
