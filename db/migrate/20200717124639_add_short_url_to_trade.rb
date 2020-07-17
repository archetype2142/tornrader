class AddShortUrlToTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :short_url, :string
  end
end
