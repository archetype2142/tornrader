class User::StatisticsController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!

  def index
    @all_trades ||= current_user.trades.group_by_day(:created_at).count
    @all_trades_count ||= current_user.trades.count
    @sellers ||= Trade.all.pluck(:seller)
    @top_seller ||= @sellers.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
    @total ||= current_user.trades.pluck(:total).sum
    @traders_data ||= @sellers.group_by(&:itself).map do |k, v| 
      next if v == 0
      [k, v.length] 
    end
  end
end



