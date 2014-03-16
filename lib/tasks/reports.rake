namespace :reports do
  desc "nightly cron email reports: followed user's recent activity and cards"
  task :followers, [:all] => :environment do |t, args|
    # get users who sent report
    users = User.includes(:follower).where(subscribed: true)

    users.each do |user|
      next if args[:all].nil? && Time.now.in_time_zone(user.time_zone).hour != 1

      followers = user.followers
      next if followers.empty?

      trello_client = TrelloWrapper::trello_client(user)

      card_boards = {}
      card_lists = {}
      members =  {}

      followers.each do |member_id|
        members[member_id] = trello_client.find(:member, member_id) unless members.has_key?(member_id)
        member = members[member_id]
        next if member.nil?

        #actions
        actions = member.actions since: Date.yesterday.to_json, limit: 1000
        actions.sort_by!(&:date).reverse!
        actions.each do |action|
          mid = action.data["idMemberAdded"]
          next if mid.nil?
          members[mid] = trello_client.find(:member, mid) unless members.has_key?(mid)
        end

        #cards
        cards = member.cards members: true
        cards.sort_by!(&:last_activity_date).reverse!
        cards.each do |card|
          card_boards[card.board_id] = card.board unless card_boards.has_key?(card.board_id)
          card_lists[card.list_id] = card.list unless card_lists.has_key?(card.list_id)
        end

        options = { actions: actions, cards: cards, members: members, card_boards: card_boards, card_lists: card_lists }
        UserMailer::follower_report(user.email, member, options)
      end
    end
  end
end
