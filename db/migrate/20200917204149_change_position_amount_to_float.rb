class ChangePositionAmountToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :positions, :amount, :float
  end
end
