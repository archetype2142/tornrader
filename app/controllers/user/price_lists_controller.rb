class User::PriceListsController < ApplicationController
  impressionist actions: [:show]
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: [:index, :show, :update_list]

  def index
    @user.update!(
      price_list: true, 
      updated_price_list_at: DateTime.now
    )

    redirect_to user_items_path, flash: { success: "Price List Successfully Created!" }
  end

  def show
    impressionist(@user) # 2nd argument is optional
  end
  
  def update_list
    @user.update!(updated_price_list_at: Time.now)
    flash.now[:success] = "Price List Updated"
    render :show
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

  def set_user
    if params[:username]
      @user ||= User.find_by(username: params[:username]) 
    else
      @user ||= current_user
    end
  end
end
