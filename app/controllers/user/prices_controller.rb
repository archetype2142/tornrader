class User::PricesController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_user, only: [:index, :create, :update]

  def destroy
    current_user.prices.delete(Price.find(params[:id]))

    redirect_to user_autoupdater_index_path, flash: { success: "Deleted!" }
  end 
end