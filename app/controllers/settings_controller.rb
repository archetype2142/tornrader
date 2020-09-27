class SettingsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :confirm_activity
  skip_before_action :confirm_subscription
  
  def index; end
end