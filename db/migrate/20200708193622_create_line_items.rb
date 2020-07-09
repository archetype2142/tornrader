class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity, default: 0
      t.references :items
    end
  end
end
