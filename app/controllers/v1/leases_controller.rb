module V1
  class LeasesController < ApplicationController
    before_action :set_lease, only: [:show, :edit, :update, :destroy]
    before_action :require_owner, only: [:new, :create, :edit, :update, :destroy]

    def index
      if current_user.owner?
        @leases = Lease.joins(:unit)
                       .where(units: { owner_id: current_user.id })
      else
        @leases = current_user.tenant.leases
      end
    end

    def show
    end

    def new
      @lease = Lease.new
    end

    def create
      @lease = Lease.new(lease_params)

      if @lease.unit.owner_id != current_user.id
        redirect_to v1_leases_path, alert: "Unauthorized"
        return
      end

      if @lease.save
        redirect_to v1_leases_path, notice: "Lease created"
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @lease.update(lease_params)
        redirect_to v1_lease_path(@lease), notice: "Lease updated successfully"
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @lease.destroy
      redirect_to v1_leases_path, notice: "Lease deleted successfully"
    end

    private

    def set_lease
      if current_user.owner?
        @lease = Lease.joins(:unit)
                      .where(units: { owner_id: current_user.id })
                      .find(params[:id])
      else
        @lease = current_user.tenant.leases.find(params[:id])
      end
    end

  
    def lease_params
        params.require(:lease).permit(:tenant_id, :unit_id, :start_date, :end_date, :rent_amount, :due_date, :status)
    end
 end
end