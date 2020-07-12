module Api
  module V1
    class TradesController < Api::ApplicationController
      def index; end

      def create
        user = User.includes(:prices, :items, :trades).find_by(torn_user_id: params[:buyer])

        trade = user.trades.find_or_create_by(
          torn_trade_id: params["trade_id"],
          seller: params["seller"]
        )

        user_items = user&.items
        user_prices = user&.prices

        items = params[:items].map do |item|

          user_item = user.items.find_by(name: item["name"])
          price = user_item.nil? ? nil : user_prices.find_by(item_id: user_item.id).amount
          
          trade.line_items.find_or_create_by(
            item: user_item,
            quantity: item["quantity"]
          ) unless price.nil?

          {
            name: "#{item["name"]}",
            id: user_item&.id, 
            price: price ? display_price(price) : nil,
            quantity: item["quantity"], 
            total: price ? display_price(price * item["quantity"].to_i) : nil,
          }
        end

        trade.update_total
        
        trade_info = {
          trade: {
            trade_url: trade_url(trade),
            trade_total: display_price(trade.total),
            items: items
          }
        }

        render json: trade_info
      end

      private 

      def display_price(amount)
        "$ #{ActiveSupport::NumberHelper::number_to_delimited(amount, delimiter: ',')}".html_safe
      end
    end
  end
end

