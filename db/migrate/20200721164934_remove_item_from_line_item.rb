class RemoveItemFromLineItem < ActiveRecord::Migration[6.0]
  def change
    remove_reference :items, :line_item, index: true
  end
end
