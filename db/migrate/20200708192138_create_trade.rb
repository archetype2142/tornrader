class CreateTrade < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.timestamps
      t.references :users
      t.references :items
    end
  end
end
