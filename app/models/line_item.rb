class LineItem < ApplicationRecord
  belongs_to :trade
  has_many :items

  before_save :update_total

  def update_total
    if self.items.any?
      total_price = (self.items.last.price * self.quantity)
      if self.total != total_price
        self.total = total_price
      end
    end
  end
end