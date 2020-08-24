class LineItemPrice < ApplicationRecord
  belongs_to :price
  belongs_to :line_item
end