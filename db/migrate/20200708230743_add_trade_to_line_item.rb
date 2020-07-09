class AddTradeToLineItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :line_items, :trade, index: true
  end
end
