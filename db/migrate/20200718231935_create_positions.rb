class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.integer :number
      t.references :user, index: true
      t.references :category, index: true
    end
  end
end
