class HomepageController < ApplicationController
  def index
    @total_trades_count = Trade.total_sum
    @traders_count = User.all.count
    @trades_count = User.all.map { |u| u.trades_count }.sum 
    @search = Item.basic.ransack(params[:q])

    @items = Kaminari.paginate_array(
        @search
        .result
        .uniq
      )
    .page(params[:page])
    .per(params[:per_page])
  end
  def offline; end
end