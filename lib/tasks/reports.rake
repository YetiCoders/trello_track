namespace :reports do
  desc "nightly cron email reports: followed user's recent activity and cards"
  task :followers, [:all] => :environment do |t, args|
    # get users who sent report
    users = User.includes(:follower).where(subscribed: true)

    users.each do |user|
      next if args[:all].nil? && Time.now.in_time_zone(user.time_zone).hour != 1

      followers = user.followers
      next if followers.empty?

      if (user.settings || {})["report_type"] == "multi"
        ActivityReport::Multi.new(user, followers).build_and_send
      else
        ActivityReport::Single.new(user, followers).build_and_send
      end
    end
  end
end
