class AddItemToLineItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :line_items, :item, index: true
  end
end
