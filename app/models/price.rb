class Price < ApplicationRecord
  belongs_to :item
  belongs_to :user

  enum auto_update: %w[not_auto_updated auto_updated]

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end