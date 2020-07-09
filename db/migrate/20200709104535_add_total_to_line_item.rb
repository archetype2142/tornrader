class AddTotalToLineItem < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :total, :integer, default: 0
  end
end
