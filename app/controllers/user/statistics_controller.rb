class User::StatisticsController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!

  def index
    @all_trades = current_user.trades.group_by_day(:created_at).count
    puts @all_trades.class
    @total = current_user.trades.count
    @traders_data ||= Trade.all.pluck(:seller).group_by(&:itself).map do |k, v| 
      next if v == 0
      [k, v.length] 
    end
  end
end



