class HomeController < ApplicationController
  skip_before_filter :check_current_user, only: :index

  def index
    if current_user
      redirect_to main_url
    end
  end

  def main
    @organizations = current_user.organizations.sort_by &:display_name
    @members = {}

    @organizations.each do |organization|
      @members[organization.id] = organization.members({ fields: ["fullName", "username", "avatarHash"] })
    end
    @followers = system_user.followers
  end
end
