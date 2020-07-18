class Category < ApplicationRecord
  has_many :items
  belongs_to :user, optional: true
  belongs_to :price, optional: true
end