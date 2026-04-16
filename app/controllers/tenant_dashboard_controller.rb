class TenantDashboardController < ApplicationController
  def index
    @tenant = current_user.tenant

    if @tenant.nil?
      redirect_to root_path, alert: "Tenant not found"
      return
    end

    @leases = @tenant.leases.includes(:payments)
    @latest_lease = @leases.last
    @payments = @tenant.payments.order(payment_date: :desc)
  end
end