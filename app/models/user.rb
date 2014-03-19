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

  def self.create_user_by_oauth_info(trello_user, data)
    user = User.find_or_initialize_by(uid: trello_user.id)
    user.name = trello_user.username
    user.oauth_token = data[:oauth_token]
    user.oauth_token_secret = data[:oauth_token_secret]
    user.time_zone = Time.zone.name
    user.save
    user
  end
end
