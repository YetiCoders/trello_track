class User < ActiveRecord::Base
  has_one :follower

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, allow_blank: true
  validates :email, presence: true, if: :subscribed?

  def followers
    self.follower ? (self.follower.member_ids || []) : []
  end

  def followers=(val)
    self.follower ||= Follower.new
    self.follower.member_ids = val
    self.follower.save
  end
end
