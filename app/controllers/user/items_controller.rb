class User::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create]

  def index
    @search = Item.basic.includes(:category).ransack(params[:q])

    @items = Kaminari.paginate_array(
      @search
      .result
      .uniq
    )
    .page(params[:page])
    .per(params[:per_page])
  end

  def update
  end

  def create
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
    redirect_to user_items_path, flash: { success: "Saved!" }
  end

  def set_user
    @user ||= current_user
  end
end
