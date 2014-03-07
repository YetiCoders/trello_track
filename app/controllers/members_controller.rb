class MembersController < ApplicationController

  def show
    @current_member = trello_user.client.find(:member, params[:id])

    @actions = @current_member.actions since: Date.yesterday.to_json

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
