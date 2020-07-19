class Category < ApplicationRecord
  has_many :items
  has_many :positions
  has_many :users, through: :positions

  belongs_to :price, optional: true
end