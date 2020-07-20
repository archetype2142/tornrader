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
    
    self.total = total_price unless self.total != total_price
  end

  def update_total_manual
    user_id = self.trade.user.id

    total_price = self.item.nil? ? 0 : (
      self.prices.first.amount * self.quantity
    )
    
    self.update!(total: total_price) unless self.total != total_price
  end
end