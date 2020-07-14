class AddGlobalPricingToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :global_pricing, :integer, default: 0, index: true
  end
end
