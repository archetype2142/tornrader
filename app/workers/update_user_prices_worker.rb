class UpdateUserPricesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    item_list.each do |item_id|
      item = Item.find_by(torn_id: item_id)
      return unless item

      uri = URI.parse("https://api.torn.com/market/#{item_id}?selections=itemmarket,bazaar&key=#{key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.get(uri.request_uri)
      response = JSON.parse(res.body)
      min_value = response.reject { |k, v| v.nil? }.values.flatten.pluck("cost").min

      item.update!(
        lowest_market_price: min_value.to_i,
        lowest_price_added_on: DateTime.now
      )
    end
  end
end
