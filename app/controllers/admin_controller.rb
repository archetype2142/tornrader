class AdminController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :confirm_activity
  skip_before_action :confirm_subscription
  before_action :ensure_admin

  def index
    @search = User.ransack(params[:q])

    @users = Kaminari.paginate_array(
        @search
        .result
        .uniq
      )
    .page(params[:page])
    .per(params[:per_page])
  end

  def ensure_admin
    current_user.admin?
  end
end
