class LineItem < ApplicationRecord
  belongs_to :trade
  has_many :items
end