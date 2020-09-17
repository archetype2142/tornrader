class ChangeUserAmountToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :amount, :float
  end
end
