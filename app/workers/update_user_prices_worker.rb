class UpdateUserPricesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    user = User.find(user_id)
    
    if user.enable_global?
      Item.all.each do |item|
        price = user.prices.find_or_create_by(
          item_id: item.id
        )
        
        price.update!(
          amount: user.weighted_average? ? average_price(price, price.profit_percentage) : calculate_price(price, price.profit_percentage),
          price_updated_at: DateTime.now
        )
      end
    else
      user.prices.each do |price|
        price.update!(
          amount: user.weighted_average? ? average_price(price, price.profit_percentage) : calculate_price(price, price.profit_percentage),
          price_updated_at: DateTime.now
        )
      end
    end
  end

  def average_price(price, profit)
    item = price.item
    if item.base_price == 0
      (10*(Point.last.price.to_f)*(1.0-profit.to_f/100.0)).floor
    elsif item.lowest_market_price == 0
      amount = (item.base_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    else
      amount = (item.average_market_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    end
  end

  def calculate_price(price, profit)
    item = price.item
    if item.base_price == 0
      (10*(Point.last.price.to_f)*(1.0-profit.to_f/100.0)).floor
    elsif item.lowest_market_price == 0
      amount = (item.base_price.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    else
      amount = ([item.lowest_market_price, item.base_price].min.to_f * (1.0-profit.to_f/100.0)).floor
      return (amount == 0 ? 1 : amount)
    end
  end
end
