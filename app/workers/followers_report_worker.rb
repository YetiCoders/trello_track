class FollowersReportWorker
  include Sidekiq::Worker

  def perform
    # get users who sent report
    users = User.includes(:follower).where(subscribed: true)

    users.each do |user|
      next if Time.now.in_time_zone(user.time_zone).hour != 1

      followers = user.followers
      next if followers.empty?

      trello_client = TrelloWrapper::trello_client(user)

      options = { members_info: {}, card_boards: {}, card_lists: {}, members: {} }

      followers.each do |member_id|
        options[:members][member_id] = trello_client.find(:member, member_id) unless options[:members].has_key?(member_id)
        member = options[:members][member_id]
        next if member.nil?

        #actions
        actions = member.actions since: Date.yesterday.to_json, limit: 1000
        actions.each do |action|
          mid = action.data["idMemberAdded"]
          next if mid.nil?
          options[:members][mid] = trello_client.find(:member, mid) unless options[:members].has_key?(mid)
        end

        #cards
        cards = member.cards members: true
        cards.sort_by!(&:last_activity_date)
        cards.each do |card|
          options[:card_boards][card.board_id] = card.board unless options[:card_boards].has_key?(card.board_id)
          options[:card_lists][card.list_id] = card.list unless options[:card_lists].has_key?(card.list_id)
        end

        options[:members_info][member_id] = { actions: actions, cards: cards }
      end

      UserMailer::followers_report(user.email, options)
    end

  end
end