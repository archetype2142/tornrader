module Api
  module V1
    class TradesController < Api::ApplicationController
      def index; end

      def create
        api_key = request.headers["Authorization"]
        buyer_flip = false

        if ((params[:buyer] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/) != nil)
          user = User.includes(:prices, :items, :trades).find_by(torn_user_id: params[:buyer])
        else
          user = User.includes(:prices, :items, :trades).find_by(torn_user_id: params[:seller])
          buyer_flip = true
        end

        if !user
          trade_info = { 
            message: "User does't use TornTrader yet"
          }
          status = 404

        elsif (user.trader_api_token == api_key) || buyer_flip
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

          trade_messages = user.messages.map{ |m| {name: m.name, message: replace_keys(m.message, user.username, params, trade)} }
          
          trade_info = {
            trade: {
              trade_url: trade_url(trade),
              trade_total: display_price(trade.total),
              items: items,
              trade_messages: trade_messages
            }
          }
          status = 200
        else
          trade_info = { 
            message: "bad api key"
          }
          status = 401
        end

        render status: status, json: trade_info
      end

      private

      def replace_keys(message, username, params, trade)
        replacements = [
          ["{trade_total}", display_price(trade&.total).to_s],
          ["{items_count}", trade&.line_items.pluck(:quantity).sum.to_s],
          ["{trade_url}", trade_url(trade).to_s],
          ["{seller_name}", params["seller"].to_s],
          ["{trader_name}", username.to_s]
        ]
        
        replacements.inject(message) { |str, (k,v)| str.gsub(k,v) }
      end

      def display_price(amount)
        "$ #{ActiveSupport::NumberHelper::number_to_delimited(amount, delimiter: ',')}".html_safe
      end
    end
  end
end

