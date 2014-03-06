class HomeController < ApplicationController
  skip_before_filter :check_current_user, only: :index

  def index
    if current_user
      redirect_to main_url
    end
  end

  def main
    @organizations = current_user.organizations
  end
end
