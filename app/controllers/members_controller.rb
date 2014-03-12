class MembersController < ApplicationController
  def show
    @current_member = trello_user.client.find(:member, params[:id])

    if request.xhr?
      render js: js_html("#tab_content", partial: "tab")
    else
      @tab_members = []
      @followers = system_user.followers

      @followers.each do |member_id|
        @tab_members << trello_user.client.find(:member, member_id)
      end

      @tab_members.sort_by!(&:full_name)
    end
  end

  def activities
    @current_member = trello_user.client.find(:member, params[:id])
    @members = {}

    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000

    @actions.each do |action|
      # if idMember exists there is member hash
      # if idMemberAdded exists there isn't member hash so we must get it
      member_id = action.data["idMemberAdded"]

      next if member_id.nil?

      @members[member_id] = trello_user.client.find(:member, member_id) unless @members.has_key? member_id
    end

    render js: js_html("#recent_activity", partial: "activity")
  end

  def cards
    @current_member = trello_user.client.find(:member, params[:id])
    @cards = @current_member.cards members: true
    @cards.sort_by!(&:last_activity_date).reverse!
    @card_boards = {}
    @card_lists = {}

    @cards.each do |card|
      @card_boards[card.board_id] = card.board unless @card_boards.has_key? card.board_id
      @card_lists[card.list_id] = card.list unless @card_lists.has_key? card.list_id
    end
    render js: js_html("#active_cards", partial: "cards")
  end

  def follow
    if params[:follow].blank?
      system_user.followers = system_user.followers - [params[:id]]
    else
      system_user.followers = system_user.followers + [params[:id]]
    end

    render nothing: true
  end
end
