class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :index

  def index; end

  def set_user
    user = User.find(params[:user]) || current_user
  end
end