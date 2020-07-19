class Category < ApplicationRecord
  has_many :items
  has_many :positions
  has_many :users, through: :positions
end