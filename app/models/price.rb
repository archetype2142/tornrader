class Price < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end