class User::ThemeController < ApplicationController
  before_action :authenticate_user!

  def create
    instance_eval "current_user.#{params[:user][:theme]}!"

    redirect_to settings_path
  end
end