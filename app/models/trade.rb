class Trade < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  has_many :items, through: :line_items
end