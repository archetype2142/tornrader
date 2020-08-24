class AddTradeCountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trades_count, :integer, default: 0
    
    User.find_each do |user|
      User.reset_counters(user.id, :trades)
    end
  end
end
