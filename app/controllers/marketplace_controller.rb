class MarketplaceController < ApplicationController
  def index
    if params[:q]
      order = params[:q][:s] ? params[:q][:s].split[1].to_sym : :desc
    else
      order = :desc
    end
    active_users ||= User.active
    if params[:q] 
      @search =
          if params[:q][:name_cont]&.blank? && params[:q][:category_id_eq]&.blank? 
            Item.where(id: 0).ransack(params[:q])
          else
            Item.basic.ransack(params[:q])
          end
    else
      @search = Item.where(id: 0).ransack(params[:q])
    end

    items ||= @search.result.pluck(:id)
    @item_names ||= Item.where(id: items).pluck(:id, :name)
    @item_names_only ||= @item_names.map{ |_, name| name }.map

    @prices = Kaminari.paginate_array(
        Price.all.includes([:user, :item])
        .where(
          user: active_users, 
          item_id: items
        )
        .order(amount: order)
        .uniq

      )
    .page(params[:page])
    .per(params[:per_page])

  end
end