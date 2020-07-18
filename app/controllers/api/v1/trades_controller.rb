module Api
  module V1
    class TradesController < Api::ApplicationController
      def index; end

      def create
        puts params
        api_key = request.headers["Authorization"]
        buyer_flip = false

        if ((params[:buyer].to_s =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/) != nil)
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
              profit: price ? display_price(
                (user_item.lowest_market_price * item["quantity"].to_i) - (price * item["quantity"].to_i)
              ) : nil
            }
          end

          trade.update_total

          trade_messages = user.messages.map{ |m| {name: m.name, message: replace_keys(m.message, user, params, trade)} }
          
          total_profit =  items.pluck(:profit).compact.map { |i| i.gsub("$", "").strip.to_i }.sum
          
          trade_info = {
            trade: {
              trade_url: url_maker(trade_url(trade)),
              trade_total: display_price(trade.total),
              items: items,
              trade_messages: trade_messages,
              total_profit: display_price(total_profit)
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

      def replace_keys(message, user, params, trade)
        replacements = [
          ["{trade_total}", display_price(trade&.total).to_s],
          ["{items_count}", trade&.line_items.pluck(:quantity).sum.to_s],
          ["{trade_url}", url_maker(trade_url(trade)).to_s],
          ["{seller_name}", params["seller"].to_s],
          ["{trader_name}", user.username.to_s],
          ["{pricelist_link}", user.short_pricelist_url.to_s],
          ["{forum_url}", user.forum_url.to_s],
          ["{price_without_delimiter}", trade&.total.to_s]
        ]
        
        replacements.inject(message) { |str, (k,v)| str.gsub(k,v) }
      end
      
      def url_maker(url_long)
        uri = URI("https://ttr.bz/urls")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        data = {url: url_long}

        request = Net::HTTP::Post.new(uri, {'Content-Type' => 'application/json'})
        request.body = data.to_json

        response = http.request(request)
        JSON.parse(response.body)["short_url"]
      end

      def display_price(amount)
        "$ #{ActiveSupport::NumberHelper::number_to_delimited(amount, delimiter: ',')}".html_safe
      end
    end
  end
end

