class LowestPriceFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true, failures: true

  def perform(item_list, key)
    item_list.each do |item_id|
      item = Item.find_by(torn_id: item_id.to_s)
      return unless item

      uri = URI.parse("https://api.torn.com/market/#{item_id}?selections=itemmarket,bazaar&key=#{key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.get(uri.request_uri)
      response = JSON.parse(res.body)

      values = response.reject { |k, v| v.nil? }.values.flatten.pluck("cost")
      min_value = values.min
      avg_value = values.count == 0 ? 0 : (values.sum / values.count)
      
      begin
        item.update!(
          lowest_market_price: min_value.to_i,
          average_market_price: avg_value,
          lowest_price_added_on: DateTime.now
        )
      rescue ActiveModel::RangeError
        return
      end
    end
  end
end
