class User::PriceListsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: [:index, :show]

  def index
    @user.update!(price_list: true)
    redirect_to user_items_path, flash: { success: "Price List Successfully Created!" }
  end

  def show
    @user.update!(updated_at: Time.now)
  end

  def set_user
    if params[:username]
      @user ||= User.find_by(username: params[:username])
    else
      @user ||= current_user
    end
  end
end
