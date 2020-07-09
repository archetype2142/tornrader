class AddItemsToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :line_item, index: true
  end
end
