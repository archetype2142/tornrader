class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:torn_api_key, :email, :torn_user_id, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || trades_path
  end

  def confirm_subscription
    if user_signed_in?
      if !current_user.subscriptions.active.any?
        redirect_to expired_sub_path
      end
    end
  end
end
