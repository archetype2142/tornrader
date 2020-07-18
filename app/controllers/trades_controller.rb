class TradesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_trade, only: :show
  before_action :confirm_subscription

  def index
    @trades = current_user.trades.limit(30)
  end

  def show; end

  def set_trade
    @trade ||= Trade.friendly.find(params[:id])
  end
end
