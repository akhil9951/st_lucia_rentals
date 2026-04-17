class DashboardController < ApplicationController
  before_action :require_owner

  def index
    @units = current_user.owned_units
    @tenants = current_user.owned_tenants
    @leases = Lease.joins(:unit).where(units: { owner_id: current_user.id })

    @units_count = @units.count
    @tenants_count = @tenants.count
    @leases_count = @leases.count

    @units = current_user.owned_units

    # Units that have active lease
    @occupied_units = Unit.where(owner_id: current_user.id, status: :occupied)
    
    @occupied_units_count = @occupied_units.count
    
    # Vacant = total - occupied
    @vacant_units_count = @units.count - @occupied_units_count
    
    # Occupancy %
    @occupancy_rate =
      if @units.count.zero?
        0
      else
        ((@occupied_units_count.to_f / @units.count) * 100).round
      end
      
    @total_revenue = Payment.joins(lease: :unit)
                            .where(units: { owner_id: current_user.id })
                            .sum(:amount)
  end
end