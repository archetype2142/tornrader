class User::AutoupdaterController < ApplicationController
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
  
  def create
    current_user.update!(
      auto_update: :auto_updated,
      pricing_rule: params[:user]['pricing_rule'],
      amount: params[:user]['amount']
    )

    redirect_to user_autoupdater_index_path, flash: { success: "Success!"}
  end

  def update; end

  def disable_global
    user = User.find(params[:id])
    user.disable_global!

    redirect_to user_autoupdater_index_path, flash: { success: "Disabled global pricing!"}
  end

  def enable_global
    user = User.find(params[:id])
    user.enable_global!

    redirect_to user_autoupdater_index_path, flash: { success: "Enabled global pricing!"}
  end

  def set_user
    @user ||= current_user
  end
end