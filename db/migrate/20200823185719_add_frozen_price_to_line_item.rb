class AddFrozenPriceToLineItem < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :frozen_price, :bigint, default: 0
  end
end
