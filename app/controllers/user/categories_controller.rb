class User::CategoriesController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create, :update]
  
  def remove_category
    user = current_user
    
    ActiveRecord::Base.transaction do
      user.prices.where(
        item: user.items.where(category_id: params[:category_id])
      ).destroy_all
      position = user.positions.find_by(category_id: params[:category_id])
      position.destroy if position
    end

    redirect_to user_autoupdater_index_path, flash: { success: "Deleted!" }
  end

  def add_category
    user = current_user

    ActiveRecord::Base.transaction do
      Category.find(params[:category_id]).items.all.each do |item|
        user.prices.find_or_create_by(
          item_id: item.id, 
          amount: 1, 
          auto_update: :auto_updated
        )
      end
      user.positions.find_or_create_by(category_id: params[:category_id])
    end

    redirect_to user_autoupdater_index_path(), flash: { success: "Added Category!" }
  end

  def set_user
    @user ||= current_user
  end
end
