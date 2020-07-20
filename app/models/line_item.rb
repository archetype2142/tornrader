class LineItem < ApplicationRecord
  belongs_to :trade
  has_one :item
  has_many :prices

  before_save :update_total

  def update_total
    user_id = self.trade.user.id

    total_price = self.item.nil? ? 0 : (
      self.prices.last.amount * self.quantity
    )
    if self.total != total_price
      self.total = total_price 
    end
  end

  def update_total_manual
    user_id = self.trade.user.id

    total_price = self.item.nil? ? 0 : (
      self.prices.first.amount * self.quantity
    )
    puts self.prices.first.amount
    puts self.quantity
    puts total_price
    puts self.total

    if self.total != total_price
      self.update!(total: total_price)
    end
  end
end