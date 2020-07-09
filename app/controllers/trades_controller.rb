class TradesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_trade, only: :show

  def index; end

  def show; end

  def set_trade
    @trade ||= Trade.friendly.find(params[:id])
  end
end