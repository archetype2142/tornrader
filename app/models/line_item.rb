class LineItem < ApplicationRecord
  belongs_to :trade
  has_many :items

  before_save :update_total

  def update_total
    if self.items.any?
      user_id = self.trade.user.id

      total_price = (
        self.items.last.prices.find_by(user_id: user_id).amount * self.quantity
      )
      
      if self.total != total_price
        self.total = total_price
      end
    end
  end
end