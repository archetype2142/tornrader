class AddForumUrlToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :forum_url, :string
  end
end
