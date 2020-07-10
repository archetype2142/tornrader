class User::PriceListsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: [:index, :show, :update_list]

  def index
    @user.update!(price_list: true, updated_price_list_at: DateTime.now)
    redirect_to user_items_path, flash: { success: "Price List Successfully Created!" }
  end

  def show; end

  def update_list
    @user.update!(updated_price_list_at: Time.now)
    flash.now[:success] = "Price List Updated"
    render :show
    # redirect_to user_items_path, flash: { success: "Price List Successfully Created!" }
  end

  def set_user
    if params[:username]
      @user ||= User.find_by(username: params[:username])
    else
      @user ||= current_user
    end
  end
end
