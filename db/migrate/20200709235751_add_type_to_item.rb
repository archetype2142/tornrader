class AddTypeToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :item_type, :integer, default: 0
  end
end
