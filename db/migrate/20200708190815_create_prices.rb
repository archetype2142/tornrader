class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.timestamps null: false
      t.references :user
      t.references :item
      t.bigint :amount, default: nil
    end
  end
end
