class AddIndexToItemName < ActiveRecord::Migration[6.0]
  def change
    add_index :items, :name
  end
end
