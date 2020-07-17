class MarketValueFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(key)
    uri = URI.parse("https://api.torn.com/torn/?selections=items&key=#{key}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.get(uri.request_uri)
    response = JSON.parse(res.body)
    
    fresh_prices = response['items'].map do |k, v|
      [ k.to_i, v['market_value'] ]
    end.to_h
    
    items ||= Item.all

    fresh_prices.each do |item_id, price|
      next if price == 0
      item = items.find_by(torn_id: item_id)
      next unless item
      next if item.base_price == price
      item.update!(base_price: price)
    end
  end
end
