class User::PriceListsOrderController < ApplicationController
  before_action :confirm_subscription
  
  def index; end
  
  def create
    action = params['price_lists_order']['request']
    user = User.find(params['price_lists_order']['userID'])
    category = params['price_lists_order']['categoryID']
    position = params['price_lists_order']['newPosition']

    if action == 'removed'
      user.positions.find_by(category_id: category.to_i).destroy
      items = user.items.where(category_id: category.to_i).pluck(:id)
      user.prices.where(item_id: items).destroy_all

    elsif action == 'added'
      user.positions << Position.new(
        number: position.to_i,
        category_id: category
      )
      items = Item.all.where(category_id: category.to_i).pluck(:id).map do |id|
        {
          item_id: id, 
          amount: 1, 
          auto_update: :auto_updated
        }
      end
      user.prices.create!(items)

    elsif action == 'reorder'
      params['list'].each do |item|
        pos = user.positions.find_by(category_id: item["category_id"].to_i)
        pos.update!(number: item["index"]) unless pos.number == item["index"]
      end
    end

    render json: {status: :ok, action: action}
  end

  def auto_update_user_prices
    UpdateUserPricesWorker.perform_async(current_user.id)

    redirect_to user_price_lists_order_index_path, flash: { success: "Please wait a few moments for prices to update"}
  end
end