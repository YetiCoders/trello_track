class UsersController < ApplicationController
  def show
  end

  def update
    params[:user][:settings] = params[:user][:settings].to_json

    if system_user.update_attributes(params[:user].permit(:email, :subscribed, :settings))
      flash[:success] = t("users.messages.settings_saved")
      redirect_to user_url
    else
      flash[:error] = system_user.errors.full_messages.join(", ")
      render :show
    end
  end
end
