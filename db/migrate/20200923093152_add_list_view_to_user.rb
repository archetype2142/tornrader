class AddListViewToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :list_view, :integer
  end
end
