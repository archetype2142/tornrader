class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :confirm_activity
  skip_before_action :confirm_subscription
  
  def create
    user = User.find(params[:user_id])
    s = user.subscriptions.new(
      ends_at: Date.strptime(params['ends_on'], "%m/%d/%Y")
    )
    if s.save
      flash = { success: "Saved!" }
    else
      flash = { error: s.errors }
    end

    redirect_to admin_index_path, flash: flash
  end

  def destroy
    s = Subscription.find(params[:id])

    if s.inactive!
      flash = { success: "Deleted!" }
    else
      flash = { error: s.errors }
    end
    
    redirect_to admin_index_path, flash: flash
  end

  def enable
    s = Subscription.find(params[:subscription_id])
    s.auto!

    redirect_to admin_index_path, flash: { success: "subscription enabled" }
  end

  def disable
    s = Subscription.find(params[:subscription_id])
    s.manual!
    
    redirect_to admin_index_path, flash: { success: "subscription disabled" }
  end
end