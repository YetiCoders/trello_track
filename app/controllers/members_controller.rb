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
    @members = {}

    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000

    threads = []
    for action in @actions
      # if idMember exists there is member hash
      # if idMemberAdded exists there isn't member hash so we must get it
      member_id = action.data["idMemberAdded"]
      next if member_id.nil? || @members.has_key?(member_id)

      # TODO use mutex too
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

    @ids = {}
    @threads = []
    @semaph = Mutex.new

    # for simultaneously getting info
    @cards.each do |card|
      # TODO cache it
      fetch_info(card, :board)
      fetch_info(card, :list)
    end
    @threads.each {|thr| thr.join }

    # TODO do not fetch list info if excluded
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
    org_id = params[:organization_id]
    # TODO avoid get organizationS, direct get by id
    @organization ||= @current_member.organizations.detect{|org| org.id == org_id}
  end

  def boards
    @boards ||= organization.boards
  end

  def search_cards_by_string(str)
    @cards = Trello::Action.search("#{str} is:open",
          modelTypes: :cards,
          idBoards: boards.map(&:id),
          cards_limit: 1000, # TODO get all
          card_members: true,
          card_fields: [:name, :badges, :idBoard, :idList, :idMembers, :dateLastActivity, :url],
        )["cards"]
  end

  def search_cards_by_member(member)
    mutex = Mutex.new
    threads = []
    cards = []
    # TODO DRY
    threads << Thread.new(member) do |mem|
      result = search_cards_by_string("@#{member.username}").to_a
      mutex.synchronize { cards.concat result }
    end
    threads << Thread.new(member) do |mem|
      result = search_cards_by_string("comment:@#{member.username}").to_a
      mutex.synchronize { cards.concat result }
    end
    threads << Thread.new(member) do |mem|
      result = search_cards_by_string("comment:@#{member.full_name}").to_a
      mutex.synchronize { cards.concat result }
    end
    threads.each {|thr| thr.join }
    cards.uniq(&:id)
  end

  def fetch_info(card, info)
    id = card.send("#{info}_id")
    @semaph.synchronize {
      return if @ids.has_key?(id)
      @ids[id] = nil
    }
    @threads << Thread.new(card) do |card_to_fetch|
      data = card_to_fetch.send(info)
      @semaph.synchronize { @ids[id] = data }
    end
  end

end
