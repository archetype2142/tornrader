class AddSellerToTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :seller, :string
  end
end
