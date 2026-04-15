class DashboardController < ApplicationController
  before_action :require_owner
  def index
    @tenants_count = Tenant.count
    @units_count = Unit.count
    @occupied_units = Unit.occupied.count
    @total_revenue = Payment.sum(:amount)
  end
end