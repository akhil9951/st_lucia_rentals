class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def after_sign_in_path_for(resource)
    if resource.owner?
      dashboard_path
    else
      tenant_dashboard_index_path
    end
  end

  private

  def require_owner
    redirect_to root_path, alert: "Access denied!" unless current_user&.owner?
  end

  def require_tenant
    redirect_to root_path, alert: "Access denied!" unless current_user&.tenant?
  end
end