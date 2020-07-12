class LineItem < ApplicationRecord
  belongs_to :trade
  has_one :item

  before_save :update_total

  def update_total
    if !self.item.nil?
      user_id = self.trade.user.id

      total_price = (
        self.item.prices.find_by(user_id: user_id).amount * self.quantity
      )
      
      if self.total != total_price
        self.total = total_price
      end
    end
  end
end