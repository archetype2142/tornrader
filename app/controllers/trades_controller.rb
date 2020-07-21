class TradesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_trade, only: [:show, :destroy]
  before_action :confirm_subscription

  def index
    @search = current_user.trades.ransack(params[:q])

    @trades = Kaminari.paginate_array(
        @search
        .result
        .uniq
      )
    .page(params[:page])
    .per(params[:per_page])
  end

  def show; end

  def destroy
    if @trade.destroy
      flash = { success: "Deleted!" }
    else
      flash = { error: @trade.errors }
    end
    redirect_to trades_path, flash: flash
  end

  def set_trade
    @trade ||= Trade.friendly.find(params[:id])
  end
end
