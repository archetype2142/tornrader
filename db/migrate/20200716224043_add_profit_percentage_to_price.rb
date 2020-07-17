class AddProfitPercentageToPrice < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :profit_percentage, :integer, default: 1
  end
end
