class AddSlugToTrades < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :slug, :string
    add_index :trades, :slug, unique: true
  end
end
