class LineItem < ApplicationRecord
  belongs_to :trade
  has_one :item
  has_many :prices

  before_save :update_total

  def update_total
    user_id = self.trade.user.id

    total_price = self.prices.any? ? (
      self.prices.first.amount * self.quantity
    ) : 0
    
    if self.total != total_price
      self.total = total_price 
    end
  end

  def update_total_manual
    user_id = self.trade.user.id

    total_price = self.prices.any? ? (
      self.prices.first.amount * self.quantity
    ) : 0

    if self.total != total_price
      self.update!(total: total_price)
    end
  end
end