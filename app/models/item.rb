class Item < ApplicationRecord  
  has_many :prices
  has_many :users, through: :prices
  
  enum item_type: %w[basic user]

  belongs_to :category, optional: true
  belongs_to :line_item, optional: true

  def user_price(user)
    user.prices.find_by(item_id: self.id)
  end
end