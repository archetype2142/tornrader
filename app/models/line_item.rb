class LineItem < ApplicationRecord
  belongs_to :trade
  has_many :items

  before_save :update_total

  def update_total
    if self.items.any?
      total_price = (self.items.last.price * self.quantity)
      self.total = total_price unless self.total == total_price
    end
  end
end