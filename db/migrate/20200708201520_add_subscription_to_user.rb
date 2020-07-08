class AddSubscriptionToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :subscriptions, :user, index: true
  end
end
