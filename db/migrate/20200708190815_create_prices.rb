class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.references :user
      t.references :item
      t.bigint :amount, default: 0
    end
  end
end
