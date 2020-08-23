class RemoveItemIdFromLineItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :line_items, :item_id
  end
end
