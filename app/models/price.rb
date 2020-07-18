class Price < ApplicationRecord
  belongs_to :item
  belongs_to :user
  has_one :category, through: :item
  
  enum auto_update: %w[auto_updated_not auto_updated]
  enum pricing_rules: %w[percentage fixed]
  # validates :amount, numericality: { only_integer: true, greater_than: 0 }
end