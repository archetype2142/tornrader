class User::CategoryPercentController < ApplicationController
  before_action :confirm_subscription
  before_action :confirm_activity
  before_action :authenticate_user!

  def update
    response = CategoryPercentSetter.execute(params[:id], params[:position]['amount'])
    position = Position.find(params[:id])
    position.update!(amount: params[:position]['amount'])  
    
    user = position.user
    items = user.items.where(category_id: position.category_id).pluck(:id)
    prices = user.prices.where(item_id: items)

    prices.each do |pr|
      pr.update!(
        amount: user.pricing_rule == 1 ? 
        average_price(pr, position.amount).to_i : 
        calculate_price(pr, position.amount).to_i,
        price_updated_at: DateTime.now
      ) unless pr.auto_updated_not?
    end
    query = params[:position][:query].nil? ? nil : eval(params[:position][:query])

    redirect_to user_autoupdater_index_path(
      per_page: params[:position][:per_page],
      page: params[:position][:page],
      q: query
    ), flash: { success: "successfully updated!"}
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
end