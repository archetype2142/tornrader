class User::PriceListMessageController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: [:index, :show, :update_list]

  def create
    user = current_user
    if user.update(message: params[:user][:message])
      flash = { success: "Saved!" }
    else
      flash = { error: user.errors }
    end
    redirect_to user_price_lists_order_index_path, flash: flash
  end
end