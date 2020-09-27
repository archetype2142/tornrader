class StaticPages::SubscriptionsController < ApplicationController
  skip_before_action :confirm_subscription
  skip_before_action :confirm_activity

  def index; end
end
