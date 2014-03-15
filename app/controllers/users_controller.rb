class UsersController < ApplicationController
  def show
  end

  def update
    if system_user.update_attributes(params[:user].permit(:email, :subscribed))
      flash[:success] = t("users.messages.settings_saved")
    else
      flash[:error] = system_user.errors.full_messages.join(", ")
    end

    render :show
  end
end
