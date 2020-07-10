class ItemsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_user, only: :index

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
end