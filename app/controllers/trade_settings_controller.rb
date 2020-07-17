class TradeSettingsController < ApplicationController
  before_action :authenticate_user!
  def index; end

  def create
    user = current_user
    if user.update(forum_url: params['user']['forum_url'])
      flash = { success: "Added successfully!" }
    else
      flash = { error: user.errors }
    end

    redirect_to trade_settings_path, flash: flash
  end
end