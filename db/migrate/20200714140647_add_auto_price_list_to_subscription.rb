class AddAutoPriceListToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :pricelist_type, :integer, default: 0
  end
end
