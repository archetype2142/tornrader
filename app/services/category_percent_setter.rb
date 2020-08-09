# frozen_string_literal: true

class CategoryPercentSetter
  class << self
    def execute(position_id, amount)
      begin
        position = Position.find(position_id)
        user = position.user
        items = user.items.where(category_id: position.category_id).pluck(:id)
        prices = user.prices.where(item_id: items)
        
        ActiveRecord::Base.transaction do
          prices.update_all(profit_percentage: amount)
        end
      rescue => error
        error 
      end
      true
    end
  end
end