# frozen_string_literal: true

class ConfirmUser
  class << self
    def execute(api_key, id)
      begin
        uri = URI.parse("https://api.torn.com/user/#{id}?key=#{api_key}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        res = http.get(uri.request_uri)
        response = JSON.parse(res.body)
        return (response["player_id"].to_i == id.to_i ? true : false )
      rescue URI::InvalidURIError
        return false
      end
    end
  end
end
