class AddPriceAndLineItemToLineItemPrice < ActiveRecord::Migration[6.0]
  def change
    add_reference :prices, :line_item_price, index: true
    add_reference :line_items, :line_item_price, index: true
  end
end
