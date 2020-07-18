class ChangeColumnToBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :line_items, :total, :bigint
  end
end
