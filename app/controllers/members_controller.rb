class MembersController < ApplicationController

  def show
    @current_member = trello_user.client.find(:member, params[:id])
    @members = {}

    #actions
    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000
    @actions.each do |action|
      member_id = action.data["idMember"] || action.data["idMemberAdded"]
      next if member_id.nil?
      @members[member_id] = trello_user.client.find(:member, member_id) unless @members.has_key? member_id
    end

    # cards
    @cards = @current_member.cards fields: :all
    @cards.sort_by!(&:last_activity_date).reverse!
    @card_boards = {}
    @card_lists = {}
    Rails.logger.debug(@cards.first.inspect)
    @cards.each do |card|
      @card_boards[card.board_id] = card.board unless @card_boards.has_key? card.board_id
      @card_lists[card.list_id] = card.list unless @card_lists.has_key? card.list_id
      card.member_ids.each do |member_id|
        @members[member_id] = trello_user.client.find(:member, member_id) unless @members.has_key? member_id
      end
    end

    if request.xhr?
      render js: js_html("#tab_content", partial: "tab")
    else
      @tab_members = []
      @followers = system_user.followers
      @followers.each do |member_id|
        @tab_members << @members[member_id] || trello_user.client.find(:member, member_id)
      end
      @tab_members.sort_by!(&:full_name)
    end
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
