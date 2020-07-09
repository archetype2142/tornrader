class Item < ApplicationRecord
  has_many :prices
  has_many :users, through: :prices

  belongs_to :category, optional: true
  belongs_to :line_item, optional: true
end