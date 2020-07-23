class PwaCopyTraderController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_subscription

  layout 'layouts/pwa'

  def index; end

  def create
    items_with_user = params[:trade_items].split('\n')
    
    begin
      items_list = split_items(params[:trade_items], current_user)
      found = false
    rescue NoMethodError
      found = true
    end

    item_found = Item.find_by(name: items_with_user[0])

    if !found
      flash = { error: "User not found, ensure you copy the whole block including user's name" }
      redr = copy_trader_index_path
    else
      user_items = current_user&.items
      user_prices = current_user&.prices
      items_list = split_items(params[:trade_items], current_user, found=true)
      
      if items_list.empty?
        flash = { error: "Bad copy, try again" }
        redr = copy_trader_index_path
      else
        trade = current_user.trades.create!(
          seller: params[:trade_items].split("\n").first
        )

        trade.update!(
          short_url: url_maker(
            trade_url(trade)
          )
        )

        trade.line_items.destroy_all if trade.line_items.any?
                
        items_list.each do |item|
          trade.line_items.create!(
            prices: [item["price_object"]],
            quantity: item["quantity"]
          ) unless item["price"] == "Price not found"
        end

        trade.update_total
        flash = { success: "Trade created!" }
        redr = pwa_copy_trader_index_path(trade_id: trade.id)
      end
    end
    redirect_to redr, flash: flash
  end

  def split_items(items, user, found=false)
    item_list = items.split("\n")
    item_list.shift if found
    item_list = item_list.map { |l| l.rstrip }

    item_list.map do |item| 
      elements = item.partition(" x")
      puts elements
      i = Item.find_by(name: elements[0].strip)
      item = user.prices.find_by(item_id: i.id)
      item_name = elements[0].strip 

      if elements.last == ""
        quantity = 1
      else
        quantity = elements.last.to_i
      end

      if !item
        price = "Price not found"
        total = 0
      else
        price = item.amount
        total = price * quantity
      end

      { "item_id" => i.id, "name" => item_name, "quantity" => quantity, "price" => price, "total" => total }
    end
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

end