class Rack::Attack
  Rack::Attack.blocklisted_response = lambda do |request|
    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 403 for blocklists by default
    [ 503, {}, ['Server Error\n']]
  end

  Rack::Attack.blocklist('fail2ban pentesters') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 2.hours) do
      # The count for the IP is incremented if the return value is truthy
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login') ||
      req.path.include?('owa') ||
      req.path.include?('ads.txt') 
      req.path.include?('php') ||
      req.path.include?('a2billing') ||
      req.path.include?('cgi') ||
      req.path.include?('webdav') ||
      req.path.include?('ona') ||
      req.path.include?('inii') ||
      req.path.include?('sarFILE') ||
      req.path.include?('global_data') ||
      req.path.include?('op5config') ||
      req.path.include?('NonExistence') ||
      req.path.include?('solr') 
    end
  end
end