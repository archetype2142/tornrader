class UpdateUserPricesWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_and_while_executing, retry: false, backtrace: true, failures: true

  def perform(user_id, add_all=false)
    user = User.find(user_id)
    return unless user.subscriptions.active.any?
    categories = user.items.pluck(:category_id).uniq

    
    if user.enable_global?
      if add_all
        Category.all.each do |c|
          user.positions.find_or_create_by(category_id: c.id)
        end
        
        Item.all.each do |item|
          begin
            price = user.prices.find_or_create_by(item_id: item.id) do |pr|
              pr.auto_updated!
            end
          rescue ActiveRecord::RecordInvalid
            next
          end

          price.update!(
            amount: user.pricing_rule == 1 ? 
            average_price(price, user.amount).to_i : 
            calculate_price(price, user.amount).to_i,
            price_updated_at: DateTime.now
          ) unless price.auto_updated_not?
        end
      else
        user.items.all.each do |item|
          price = user.prices.find_by(item_id: item.id)
          next unless price
          
          price.update!(
            amount: user.pricing_rule == 1 ? 
            average_price(price, user.amount).to_i : 
            calculate_price(price, user.amount).to_i,
            price_updated_at: DateTime.now
          ) unless price.auto_updated_not?
        end
      end
    else
      user.prices.each do |price|
        price.update!(
          amount: user.pricing_rule == 1 ? average_price(price, price.profit_percentage) : calculate_price(price, price.profit_percentage),
          price_updated_at: DateTime.now
        ) unless (price.auto_updated_not? || !categories.include?(price.item.category.id))
      end
    end
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
    elsif item.average_market_price <= 2
      amount = calculate_price(price, profit)
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
