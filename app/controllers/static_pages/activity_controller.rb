class StaticPages::ActivityController < ApplicationController
  skip_before_action :confirm_subscription
  skip_before_action :confirm_activity

  def index; end

  def reactivate
    current_user.active!
    redirect_to root_path, flash: { success: "Your account has been activated!" }
  end
end
