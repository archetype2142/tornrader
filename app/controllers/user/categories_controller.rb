class User::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create, :update]
  
  def remove_category
    user = current_user
    puts params[:category_id]
    
    user.prices.where(
      item: user.items.where(category_id: params[:category_id])
    ).destroy_all

    redirect_to user_autoupdater_index_path, flash: { success: "Deleted!" }
  end

  def add_category
  end

  def set_user
    @user ||= current_user
  end
end