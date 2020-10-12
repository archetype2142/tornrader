class TraderItemsController < ApplicationController

  def index
    active_users ||= User.active
    @search = Item.basic.ransack(params[:q])

    items ||= @search.result.pluck(:id)
    @item_names ||= Item.where(id: items).pluck(:id, :name)

    @prices = Kaminari.paginate_array(
        Price.all.includes([:user]).where(user: active_users, item_id: items).uniq
      )
    .page(params[:page])
    .per(params[:per_page])
  end
end