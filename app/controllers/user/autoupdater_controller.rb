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

    @search ||= Item.basic.includes(:category).ransack(params[:q])

    @items ||= Kaminari.paginate_array(
      @search
      .result
      .uniq
    )
    .page(page)
    .per(per_page)
  end
  
  def create
    if current_user.update(
        auto_update: :auto_updated,
        pricing_rule: params['user']['pricing_rule'],
        amount: params[:user]['amount']
      )
    
      UpdateUserPricesWorker.perform_async(current_user.id)

      flash = { success: "Success! please wait some time for changes to take place, <span class='has-text-danger' style='background: white'><b>refresh trade page to see new prices</b></span>"}
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
      amount: calculate_price(price, params[:user]['profit_percentage']),
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

  def calculate_price(price, profit)
    item = price.item
    
    if item.base_price == 0
      (10*(Point.last.price.to_f)*(1.0-profit.to_f/100.0)).floor
    else
      amount = ([item.lowest_market_price, item.base_price].min.to_f * (1.0-profit.to_f/100.0)).floor
    end
  end

  def disable_global
    user = User.find(params[:id])
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