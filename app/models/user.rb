class User < ActiveRecord::Base
  has_one :follower

  def followers
    self.follower ? (self.follower.member_ids || []) : []
  end

  def followers=(val)
    self.follower ||= Follower.new
    self.follower.member_ids = val
    self.follower.save
  end
end
