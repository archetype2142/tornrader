class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    s = user.subscriptions.new(ends_at: Date.strptime(params['ends_on'], "%m/%d/%Y"))
    if s.save
      flash = { success: "Saved!" }
    else
      flash = { error: s.errors }
    end

    redirect_to admin_index_path, flash: flash
  end

  def destroy
    s = Subscription.find(params[:id])

    if s.destroy
      flash = { success: "Deleted!" }
    else
      flash = { error: s.errors }
    end
    
    redirect_to admin_index_path, flash: flash
  end
end