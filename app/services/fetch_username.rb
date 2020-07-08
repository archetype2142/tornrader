# frozen_string_literal: true

class FetchUsername
  class << self
    def execute(id)
      user = User.find(id)
      begin
        uri = URI.parse("https://api.torn.com/user/#{user.torn_user_id}?key=#{user.torn_api_key}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        res = http.get(uri.request_uri)
        response = JSON.parse(res.body)
        user.update!(username: response['name'])
      rescue URI::InvalidURIError
        return false
      end
    end
  end
end
