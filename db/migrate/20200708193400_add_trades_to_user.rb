class AddTradesToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :trades, :user, index: true
  end
end
