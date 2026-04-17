module V1
  class PaymentsController < ApplicationController
    before_action :require_owner, only: [:new, :create]

    def new
      @payment = Payment.new
      @leases = current_user.owned_units.includes(:leases).map(&:leases).flatten
    end

    def create
      lease = Lease.joins(:unit)
                   .where(units: { owner_id: current_user.id })
                   .find_by(id: payment_params[:lease_id])

      if lease.nil?
        redirect_to v1_units_path, alert: "Unauthorized lease"
        return
      end

      @payment = lease.payments.build(payment_params.except(:tenant_id))
      @payment.tenant = lease.tenant   # 🔥 auto assign (secure)

      if @payment.save
        redirect_to v1_lease_path(lease), notice: "Payment added successfully"
      else
        render :new
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:lease_id, :amount, :payment_date, :status, :transaction_id)
    end
  end
end