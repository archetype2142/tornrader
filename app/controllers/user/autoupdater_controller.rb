class User::AutoupdaterController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create, :update]

  def index
    cookies[:page] = nil unless params[:page]
    cookies[:per_page] = nil unless params[:page]

    if params[:per_page]
      cookies[:per_page] = params[:per_page].to_s
      per_page = params[:per_page].to_s
    end
    
    if params[:page]
      cookies[:page] = params[:page].to_s
      page = params[:page].to_s
    end
    
    if cookies[:per_page]
      per_page = cookies[:per_page].to_s
    end

    if cookies[:page]
      page = cookies[:page].to_s
    end

    @search ||= Item.basic.ransack(params[:q])

    @items ||= Kaminari.paginate_array(
      @search
      .result
      .uniq
    )
    .page(page)
    .per(per_page)
  end

  def all_items_adder
    UpdateUserPricesWorker.perform_async(current_user.id, add_all=true)
    
    redirect_to user_autoupdater_index_path, flash: {success: "Success! please wait some time for changes to take place, <span class='has-text-danger' style='background: white'><b>refresh page to see new prices, also refresh page before using chrome extension</b></span>"}
  end

  def create
    if current_user.update(
        auto_update: :auto_updated,
        pricing_rule: params['user']['pricing_rule'],
        amount: params[:user]['amount']
      )

      current_user.positions.update_all(amount: params[:user]['amount'])
      UpdateUserPricesWorker.perform_async(current_user.id, add_all=false)

      flash = { success: "Success! please wait some time for changes to take place, <span class='has-text-danger' style='background: white'><b>refresh page to see new prices, also refresh page before using chrome extension</b></span>"}
    else
      flash = { error: current_user.errors }
    end

    redirect_to user_autoupdater_index_path, flash: flash
  end

  def update
    query = params[:user][:query].nil? ? nil : eval(params[:user][:query])
    price = @user.prices.find_or_create_by(item_id: params[:user]['item'])

    if price.update(
      profit_percentage: params[:user]['profit_percentage'],
      amount: @user.pricing_rule == 1 ? average_price(price, params[:user]['profit_percentage']) : calculate_price(price, params[:user]['profit_percentage']),
      price_updated_at: DateTime.now,
      auto_update: :auto_updated
    )
      flash = { success: "successfully updated!"}
    else
      flash = { error: price.errors }
    end
    
    redirect_to user_autoupdater_index_path(
      per_page: params[:user][:per_page],
      page: params[:user][:page],
      q: query
    ), flash: flash
  end

  def average_price(price, profit)
    item = price.item
    if item.base_price == 0 && item.lowest_market_price == 0
      (10*(Point.last.price.to_f)*(1.0-profit.to_f/100.0)).floor
    elsif item.lowest_market_price == 0 && item.base_price != 0
      amount = (item.base_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    elsif item.lowest_market_price != 0 && item.base_price == 0
      amount = (item.lowest_market_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    else
      amount = (item.average_market_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    end
  end

  def calculate_price(price, profit)
    item = price.item
    if item.base_price == 0 && item.lowest_market_price == 0
      (10*(Point.last.price.to_f)*(1.0-profit.to_f/100.0)).floor
    elsif item.lowest_market_price == 0 && item.base_price != 0      
      amount = (item.base_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    elsif item.lowest_market_price != 0 && item.base_price == 0      
      amount = (item.lowest_market_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    else
      amount = ([item.lowest_market_price, item.base_price].min.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    end
  end

  def disable_global
    user = User.find(params[:id])
    user.prices.update_all(profit_percentage: user.amount)
    user.disable_global!

    redirect_to user_autoupdater_index_path, flash: { success: "Disabled global pricing!"}
  end

  def enable_global
    user = User.find(params[:id])
    user.enable_global!
    user.prices.update_all(auto_update: :auto_updated)

    redirect_to user_autoupdater_index_path, flash: { success: "Enabled global pricing!"}
  end

  def set_user
    @user ||= current_user
  end
end