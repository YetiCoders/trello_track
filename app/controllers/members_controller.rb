class MembersController < ApplicationController

  def show
    @current_member = trello_user.client.find(:member, params[:id])

    @actions = @current_member.actions since: Date.yesterday.to_json, limit: 1000
    @member_actions = {}
    @actions.each do |action|
      member_id = action.data["idMember"] || action.data["idMemberAdded"]
      next if member_id.nil?
      next if @member_actions.has_key? member_id
      @member_actions[member_id] = trello_user.client.find(:member, member_id)
    end

    if request.xhr?
      render js: js_html("#tab_content", partial: "tab")
    else
      @members = []
      @followers = system_user.followers
      @followers.each do |member_id|
        @members << trello_user.client.find(:member, member_id)
      end
      @members.sort_by!(&:full_name)
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
