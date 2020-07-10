class User::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :index

  def index; end

  def update; end

  def create; end

  def set_user
    @user ||= current_user
  end
end
