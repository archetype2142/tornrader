class CopyTraderController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_subscription

  def index
    if params[:trade_id]
      found_trade = Trade.find(params[:trade_id])
      @trade = found_trade if current_user == found_trade.user
    end
  end

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
          short_url: current_user.shortened? ? url_maker(trade_url(trade)) : trade_url(trade)
        )

        trade.line_items.destroy_all if trade.line_items.any?
        all_items = items_list

        # 1048 and 1049 are item ids for plusie set and flower set respectively
        if user_prices.where(item_id: [1048, 1049]).count == 2
          flowers_checked = flower_set_exists?(items_list, user_prices.find_by(item_id: 1049))
          plushie_checked = plushie_set_exists?(flowers_checked, user_prices.find_by(item_id: 1048))
          all_items = plushie_checked
        end

        all_items.each do |item|
          puts item.inspect
          trade.line_items.create!(
            prices: [item["price_object"]],
            quantity: item["quantity"],
            frozen_price: item["price_object"].amount
          ) unless item["price"] == "Price not found"
        end

        trade.line_items.map(&:update_total_manual)
        trade.update_total
        flash = { success: "Trade created!" }
        redr = copy_trader_index_path(trade_id: trade.id)
      end

    end
    redirect_to redr, flash: flash
  end

  def show
  end

  def split_items(items, user, found=false)
    item_list = items.split("\n")
    item_list.shift if found
    item_list = item_list.map(&:lstrip).reject { |c| c.empty? }
    
    item_list.map do |item| 
      elements = item.partition(" x")

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

      { "item_id" => i.id, "name" => item_name, "quantity" => quantity, "price_object" => item, "price" => price, "total" => total }
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

  def plushie_set_exists?(items, price)
    plushies ||= ["Sheep Plushie", "Teddy Bear Plushie", "Kitten Plushie",
    "Jaguar Plushie", "Wolverine Plushie", "Nessie Plushie",
    "Red Fox Plushie", "Monkey Plushie", "Chamois Plushie",
    "Panda Plushie", "Lion Plushie", "Camel Plushie"]
    new_items = items
    if (plushies - new_items.pluck("name")).empty?
      found_plushies = []
      
      plushies.each do |plush|
        found_plushies.push(new_items.select{ |i| i["name"].to_s == plush })
      end
      found_plushies.flatten!
      new_items = new_items - found_plushies

      sets_amount_found = found_plushies.pluck("quantity").min

      set_items_after_removed = found_plushies.select { |plush| plush["quantity"] > sets_amount_found }
      set_items_after_removed.each{ |i| i["quantity"] -= sets_amount_found}
      
      new_items.push({"name" => "Plushie Set", "quantity" => sets_amount_found, "price_object" => price})
      new_items.push(set_items_after_removed)
      new_items.flatten!
    end
    return new_items
  end

  def flower_set_exists?(items, price)
    flowers ||= ["African Violet", "Banana Orchid", "Cherry Blossom", 
    "Ceibo Flower", "Crocus", "Dahlia", "Edelweiss", "Heather", 
    "Orchid", "Peony", "Tribulus Omanense"]

    new_items = items

    if (flowers - new_items.pluck("name")).empty?
      found_flowers = []
      
      flowers.each do |plush|
        found_flowers.push(new_items.select{ |i| i["name"].to_s == plush })
      end
      found_flowers.flatten!
      new_items = new_items - found_flowers

      sets_amount_found = found_flowers.pluck("quantity").min
      set_items_after_removed = found_flowers.select { |plush| plush["quantity"] > sets_amount_found }
      set_items_after_removed.each{ |i| i["quantity"] -= sets_amount_found}
      
      new_items.push({"name" => "Flower Set", "quantity" => sets_amount_found, "price_object" => price})
      new_items.push(set_items_after_removed)
      new_items.flatten!
    end
    return new_items
  end
end
