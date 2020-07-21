SitemapGenerator::Sitemap.default_host = "https://torntrader.com"
SitemapGenerator::Sitemap.ping_search_engines('https://torntrader.com/sitemap.xml.gz')

SitemapGenerator::Sitemap.create do
  add '/contact'
  add '/users/sign_up'
  
  User.find_each do |user|
    next unless user.price_list
    add user_price_list_path(username: user.username), lastmod: user.updated_at
  end
end
