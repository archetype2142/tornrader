class User::EmbedListsController < ApplicationController
  layout 'embed_template'
  
  def show
    @user ||= User.find_by(username: params[:id])
  end
end