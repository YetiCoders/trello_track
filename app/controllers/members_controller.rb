class MembersController < ApplicationController
  before_action :current_member, only: [:show, :activities, :cards]
  helper_method :organization

  def show
    redirect_to main_url and return if organization.nil?

    if request.xhr?
      render js: js_html("#tab_content", partial: "tab")
    else
      @tab_members = organization.members({ fields: ["fullName", "username", "avatarHash"] }).sort_by(&:full_name)
      @followers = system_user.followers
    end
  end

  def activities
    @members = {}

    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000

    threads = []
    for action in @actions
      # if idMember exists there is member hash
      # if idMemberAdded exists there isn't member hash so we must get it
      member_id = action.data["idMemberAdded"]
      next if member_id.nil? || @members.has_key?(member_id)

      @members[member_id] = nil
      threads << Thread.new(member_id) do |fetch_id|
        @members[fetch_id] = fetch_member(fetch_id)
      end
    end
    threads.each {|thr| thr.join }

    render js: js_html("#recent_activity", partial: "activity")
  end

  def cards
    @cards = @current_member.cards(members: true)
    @cards.sort_by!(&:last_activity_date).reverse!

    @ids = {}
    @threads = []

    @cards.each do |card|
      fetch_info(card, :board)
      fetch_info(card, :list)
    end
    @threads.each {|thr| thr.join }

    # user filter
    @cards = CardsFilter.apply_user_filter(@system_user, @cards, @ids)

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

  private

  def current_member
    @current_member ||= fetch_member(params[:id])
    redirect_to main_url if @current_member.nil?
  end

  def organization
    @organization ||= @current_member.organizations.select{|org| org.id == params[:organization_id]}.first
  end

  def fetch_info(card, info)
    id = card.send("#{info}_id")
    return if @ids.has_key?(id)
    @threads << Thread.new(card) do |card_to_fetch|
      @ids[id] = card_to_fetch.send(info)
    end
  end

end
