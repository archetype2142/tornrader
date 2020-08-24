class AddVotesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :votes, :integer
  end
end
