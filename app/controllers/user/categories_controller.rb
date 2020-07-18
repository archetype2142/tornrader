class User::CategoriesController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create, :update]
  
  def remove_category
    user = current_user
    
    user.prices.where(
      item: user.items.where(category_id: params[:category_id])
    ).destroy_all

    redirect_to user_autoupdater_index_path, flash: { success: "Deleted!" }
  end

  def add_category
    user = current_user
    Category.find(params[:category_id]).items.all.each do |item|
      user.prices.find_or_create_by(
        item_id: item.id, 
        amount: 1, 
        auto_update: :auto_updated
      )
    end

    redirect_to user_autoupdater_index_path(), flash: { success: "Added Category!" }
  end

  def set_user
    @user ||= current_user
  end
end
