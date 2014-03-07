class HomeController < ApplicationController
  skip_before_filter :authenticate, only: :index

  def index
    redirect_to main_url if trello_user
  end

  def main
    @organizations = trello_user.organizations.sort_by(&:display_name)
    @members = {}

    @organizations.each do |organization|
      @members[organization.id] = organization.members({ fields: ["fullName", "username", "avatarHash"] })
    end
    @followers = system_user.followers
  end
end
