class User::PricesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    query = params[:query].nil? ? nil : params[:query]

    current_user.prices.delete(Price.find(params[:id]))

    redirect_to user_autoupdater_index_path(
      per_page: params[:per_page],
      page: params[:page],
      q: query&.to_unsafe_h
    ), flash: { success: "Deleted!" }
  end 

  def update
    query = params[:query].nil? ? nil : params[:query]

    current_user.prices.find(params[:id]).auto_updated!

    redirect_to user_autoupdater_index_path(
      per_page: params[:per_page],
      page: params[:page],
      q: query&.to_unsafe_h
    ), flash: { success: "Added back to automatic pricing!" }
  end
end