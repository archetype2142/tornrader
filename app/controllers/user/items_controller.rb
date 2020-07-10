class User::ItemsController < ApplicationController
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

    @search ||= Item.basic.includes(:category).ransack(params[:q])

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
      @user.prices.find_by(item_id: item.id)
      .update!(
        amount: params[:user]["price"]
      )
    else
      @user.prices.create!(
        item: Item.find(params[:user]["item"]),
        amount: params[:user]["price"]
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
    @user ||= current_user
  end
end
#Parameters: {"q"=>{"name_cont"=>"chocolate", "category_id_eq"=>""}, "commit"=>"Filter"}
# "{\"name_cont\"=>\"chocolate\", \"category_id_eq\"=>\"\"}"}

