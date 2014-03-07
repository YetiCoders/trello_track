class MembersController < ApplicationController

  def show
    @current_member = trello_user.client.find(:member, params[:id])

    @members = []
    @followers = system_user.followers
    @followers.each do |member_id|
      @members << trello_user.client.find(:member, member_id)
    end
    @members.sort_by!(&:full_name)

    @member = trello_user.client.find(:member, params[:id])
#    Rails.logger.info "=========== #{1.day.ago.to_json}"
    @actions = @member.actions #:since => 1.day.ago.to_json
#    Rails.logger.info "=========== #{@actions.count}"
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
