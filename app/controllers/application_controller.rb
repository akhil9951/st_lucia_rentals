class ApplicationController < ActionController::Base
    before_action :authenticate_user!
  
    def after_sign_in_path_for(user)
      if user.owner?
        dashboard_path
      else
        tenant_dashboard_index_path
      end
    end
  
    private
  
    def require_owner
      redirect_to root_path, alert: "Access denied!" unless current_user&.owner?
    end
  end