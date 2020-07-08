class Item < ApplicationRecord
  has_many :item_lists
  has_many :users, through: :item_lists

  belongs_to :category, optional: true
end