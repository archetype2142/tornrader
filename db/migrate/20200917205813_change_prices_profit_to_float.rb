class ChangePricesProfitToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :prices, :profit_percentage, :float
  end
end
