class AddPriceListToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :price_list, :boolean, default: false
  end
end
