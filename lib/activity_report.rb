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

    def board_by_id(board_id)
      boards[board_id] = trello_client.find(:board, board_id) unless boards.has_key?(board_id)
    end

    def list_by_id(list_id)
      lists[list_id] = trello_client.find(:list, list_id) unless lists.has_key?(list_id)
    end

    def actions(member)
      actions = member.actions since: Date.yesterday.to_json, limit: 1000
      actions.sort_by!(&:date).reverse!
      actions.each do |action|
        mid = action.data["idMemberAdded"]
        member_by_id(mid) unless mid.nil?
      end
    end

    def cards(member)
      cards = member.cards members: true
      cards.sort_by!(&:last_activity_date).reverse!
      cards.each do |card|
        board_by_id(card.board_id)
        list_by_id(card.list_id)
      end

      ::CardsFilter.apply_user_filter(recipient, cards, lists)
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
        member = self.member_by_id(member_id)
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