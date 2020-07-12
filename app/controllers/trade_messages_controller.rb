class TradeMessagesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    message = current_user.messages.new(
      message: params[:message],
      name: params[:name]
    ) unless current_user.messages.count > 5

    flash = current_user.messages.count < 5 ? { success: "Message added!" } : { danger: "Only 5 messages allowed!" }


    if message.save
      flash = { success: "Message added!" }
    else 
      flash = { error: message.errors }
    end

    redirect_to trade_settings_path, flash: flash
  end

  def destroy
    message = Message.find(params[:id])

    if message.destroy
      flash = { success: "Message deleted successfully!" }
    else
      flash = { error: message.errors }
    end

    redirect_to trade_settings_path, flash: flash
  end

end