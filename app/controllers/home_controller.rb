class HomeController < ApplicationController
  skip_before_filter :authenticate, only: :index

  def index
    redirect_to main_url if trello_user
  end

  def main
    @organizations = trello_user.organizations.sort_by(&:display_name)
    @members = {}

    threads = []
    @organizations.each do |organization|
      threads << Thread.new(organization) do |org|
        @members[org.id] = org.members({ fields: ["fullName", "username", "avatarHash"] })
      end
    end
    threads.each {|thr| thr.join }

    @followers = system_user.followers
  end
end
