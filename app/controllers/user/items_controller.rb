class User::ItemsController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create]

  def index
    cookies[:page] = nil unless params[:page]
    cookies[:per_page] = nil unless params[:page]

    if params[:per_page]
      cookies[:per_page] = params[:per_page].to_s
      per_page = params[:per_page].to_s
    end
    
    if params[:page]
      cookies[:page] = params[:page].to_s
      page = params[:page].to_s
    end
    
    if cookies[:per_page]
      per_page = cookies[:per_page].to_s
    end

    if cookies[:page]
      page = cookies[:page].to_s
    end

    @search ||= Item.basic.ransack(params[:q])

    @items ||= Kaminari.paginate_array(
      @search
      .result
      .uniq
    )
    .page(page)
    .per(per_page)
  end

  def update
  end

  def create
    query = params[:user][:query].nil? ? nil : eval(params[:user][:query])

    item = @user.items.find_by(id: params[:user]["item"])
    if item
      price = @user.prices.find_by(item_id: item.id)
      if params[:user]["price"].to_i > 0
        price.update!(
          amount: params[:user]["price"],
          auto_update: :auto_updated_not,
          price_updated_at: DateTime.now
        )
      else
        @user.prices.delete(price)
      end
    else
      @user.prices.create!(
        item: Item.find(params[:user]["item"]),
        amount: params[:user]["price"],
        auto_update: :auto_updated_not,
        price_updated_at: DateTime.now
      )
    end
    # query = nil
    # query = params[:user]['query']
    redirect_to user_items_path(
      per_page: params[:user][:per_page],
      page: params[:user][:page],
      q: query
    ), flash: { success: "Saved!" }
  end

  def set_user
    @user ||= User.find(current_user.id)
  end
end

