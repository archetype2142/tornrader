class UpdateUserPricesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    user = User.find(user_id)
    Item.all.each do |item|

      price = user.prices.find_or_create_by(
        item_id: item.id
      )
      
      puts "id: #{item.torn_id}, new_p: #{amount_calculator(
        user.pricing_rule,
        item.lowest_market_price,
        user.amount
      ).ceil}, old_p: #{item.lowest_market_price}"

      price.update!(
        amount: amount_calculator(
          user.pricing_rule,
          item.lowest_market_price,
          user.amount
        ).ceil,
        price_updated_at: DateTime.now
      )
    end
  end

  def amount_calculator(rule, real_amount, to_change)
    final_price = 0
    puts "REAL: #{real_amount}, CHANGE: #{to_change}"
    if real_amount
      if rule == 0
        if to_change.positive?
          if real_amount = 0
            final_price = 0
          else
            final_price = real_amount + real_amount * (to_change.to_f / real_amount.to_f)
          end
        else
          to_change = to_change.abs
          final_price = real_amount - real_amount * (to_change.to_f / real_amount.to_f)
        end
      else
        final_price = real_amount + to_change
      end
    end
    
    final_price <= 0 ? 1 : final_price
  end
end
