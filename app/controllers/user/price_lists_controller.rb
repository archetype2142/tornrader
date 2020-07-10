class User::PriceListsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: [:index, :show]

  def index
    @user.update!(price_list: true)
    redirect_to user_items_path, flash: { success: "Price List Successfully Created!" }
  end

  def show
  end

  def set_user
    @user ||= current_user
  end
end
