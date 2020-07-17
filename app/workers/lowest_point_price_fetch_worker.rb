class LowestPointPriceFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(key)
    uri = URI.parse("https://api.torn.com/market/?selections=pointsmarket&key=#{key}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.get(uri.request_uri)
    response = JSON.parse(res.body)
    lowest_price = response.values.flatten.map { |a| a.values.pluck("cost") }.flatten.min
    Point.last.update!(price: lowest_price)
  end
end
