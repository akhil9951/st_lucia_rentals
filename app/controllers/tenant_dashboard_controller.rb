class TenantDashboardController < ApplicationController
  def index
    @tenant = current_user.tenant

    # ✅ Prevent crash
    if @tenant.nil?
      redirect_to root_path, alert: "Tenant profile not found"
      return
    end

    @leases = @tenant.leases
    @payments = @tenant.payments
  end
end