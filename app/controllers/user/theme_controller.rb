class User::ThemeController < ApplicationController

  def create
    instance_eval "current_user.#{params[:user][:theme]}!"

    redirect_to settings_path
  end
end