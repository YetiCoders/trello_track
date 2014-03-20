module ActivityReport
  class Base
    attr_reader :recipient, :followers, :trello_client
    attr_accessor :members, :lists, :boards

    def initialize(recipient, followers)
      @recipient = recipient
      @trello_client = TrelloWrapper::trello_client(recipient)
      @followers = followers
      @members = {}
      @lists = {}
      @boards = {}
    end

    def member_by_id(member_id)
      members[member_id] = trello_client.find(:member, member_id) unless members.has_key?(member_id)
      members[member_id]
    end

    def actions(member)
      actions = member.actions since: Date.yesterday.to_json, limit: 1000
      actions.sort_by!(&:date).reverse!
      actions.each do |action|
        mid = action.data["idMemberAdded"]
        next if mid.nil?
        members[mid] = trello_client.find(:member, mid) unless members.has_key?(mid)
      end
    end

    def cards(member)
      cards = member.cards members: true
      cards.sort_by!(&:last_activity_date).reverse!
      cards.each do |card|
        boards[card.board_id] = card.board unless boards.has_key?(card.board_id)
        lists[card.list_id] = card.list unless lists.has_key?(card.list_id)
      end
    end
  end

  # many emails - one email for one follower
  class Multi < ActivityReport::Base
    def build_and_send
      followers.each do |member_id|
        member = member_by_id(member_id)
        next if member.nil?

        options = {
          actions: self.actions(member),
          cards: self.cards(member),
          members: members,
          card_boards: boards,
          card_lists: lists
        }
        UserMailer::follower_report(recipient.email, member, options)
      end
    end
  end

  # one email with all followers
  class Single < ActivityReport::Base
    def build_and_send
      members_info = {}

      followers.each do |member_id|
        member = member_by_id(member_id)
        next if member.nil?

        members_info[member_id] = {
          actions: self.actions(member),
          cards: self.cards(member)
        }
      end

      options = {
        members_info: members_info,
        members: members,
        card_boards: boards,
        card_lists: lists
      }
      UserMailer::followers_report(recipient.email, options)
    end
  end
end