require 'multiuser_action'

class MembersController < ApplicationController
  before_action :current_member, except: [:follow]
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

    @actions = []
    @members = {}

    # search in member actions since yesterday
    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000
    @actions = @actions.select{|a| boards.map(&:id).include? a.data["board"]["id"] }

    # search in comments
    @actions_by_comments = search_actions_by_member_in_comments(@current_member)
    @actions.push *@actions_by_comments
    @actions.uniq!(&:id)
    @actions.sort_by!(&:date).reverse!

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
    @cards = search_cards_by_member(@current_member)
    @cards.sort_by!(&:last_activity_date).reverse!

    @cards = filter_cards(@cards)

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
    org_id = params[:organization_id]
    # TODO avoid get organizationS, direct get by id
    @organization ||= @current_member.organizations.detect{|org| org.id == org_id}
  end

  def boards
    @boards ||= organization.boards
  end

  def filter_cards(cards)
    @ids = {}
    @threads = []
    @semaph = Mutex.new

    # for simultaneously getting info
    cards.each do |card|
      # TODO cache it
      fetch_info(card, :board)
      fetch_info(card, :list)
    end
    @threads.each {|thr| thr.join }

    # TODO do not fetch list info if excluded
    CardsFilter.apply_user_filter(@system_user, cards, @ids)
  end

  def search_cards_by_string(str)
    MultiuserAction.new(system_user).search("#{str} is:open",
      modelTypes: :cards,
      idBoards: boards.map(&:id),
      cards_limit: 1000, # TODO get all
      card_members: true,
      card_fields: [:name, :badges, :idBoard, :idList, :idMembers, :dateLastActivity, :url],
    )["cards"]
  end

  def search_cards_by_string_in_comments(str)
    MultiuserAction.new(system_user).
      search("comment:#{str} is:open",
        modelTypes: :cards,
        idBoards: boards.map(&:id),
        cards_limit: 1000, # TODO get all
        card_fields: [:id, :dateLastActivity]
      )["cards"].select{|c| c.last_activity_date > Date.yesterday}
  end

  def search_card_actions_by_string_in_comments(cards, strings)
    selected_actions = []
    cards.each do |card|
      card.client = trello_client
      actions = card.actions(since: Date.yesterday.to_json, filter: :commentCard, member: true)
      selected_actions.push *actions.select do |a|
        strings.any?{|str| a.data["text"].include?(str)}
      end
    end
    selected_actions.uniq(&:id)
  end

  def search_actions_by_member_in_comments(member)
    mutex = Mutex.new
    threads = []
    cards = []

    user_search = ["@" + member.username, member.full_name]

    user_search.each do |str|
      threads << Thread.new(member) do |mem|
        result = search_cards_by_string_in_comments(str).to_a
        mutex.synchronize { cards.concat result }
      end
    end
    threads.each {|thr| thr.join }

    cards.uniq!(&:id)
    search_card_actions_by_string_in_comments(cards, user_search)
  end

  def search_cards_by_member(member)
    cards = search_cards_by_string("@#{member.username}").to_a
    cards.uniq(&:id)
  end

  def fetch_info(card, info)
    id = card.send("#{info}_id")
    @semaph.synchronize {
      return if @ids.has_key?(id)
      @ids[id] = nil
    }
    @threads << Thread.new(card) do |card_to_fetch|
      card_to_fetch.client = trello_client
      data = card_to_fetch.send(info)
      @semaph.synchronize { @ids[id] = data }
    end
  end

end
