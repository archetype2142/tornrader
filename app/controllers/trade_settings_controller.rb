class TradeSettingsController < ApplicationController
  before_action :authenticate_user!
  def index; end

  def create
    user = current_user

    if user.update(permitted_params)
      flash = { success: "Saved successfully!" }
    else
      flash = { error: user.errors }
    end

    redirect_to trade_settings_path, flash: flash
  end

  private

  def permitted_params
    params.require(:user).permit(:forum_url, :short_url)
  end
end