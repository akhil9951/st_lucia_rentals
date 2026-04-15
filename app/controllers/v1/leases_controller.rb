module V1
    class LeasesController < ApplicationController
      before_action :set_lease, only: [:show]
  
      def index
        @leases = Lease.includes(:tenant, :unit)
      end
  
      def show
      end
  
      def new
        @lease = Lease.new
      end
  
      def create
        @lease = Lease.new(lease_params)
  
        if @lease.save
          redirect_to v1_lease_path(@lease), notice: "Lease created"
        else
          render :new
        end
      end
  
      private
  
      def set_lease
        @lease = Lease.find(params[:id])
      end
  
      def lease_params
        params.require(:lease).permit(:tenant_id, :unit_id, :start_date, :end_date, :rent_amount, :due_date, :status)
      end
    end
end