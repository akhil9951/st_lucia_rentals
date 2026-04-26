module V1
  class PaymentsController < ApplicationController
    before_action :require_tenant, only: [:new, :create_order, :verify]

    def new
      @lease = current_user.tenant.leases.includes(:tenant, :unit).find_by(id: params[:lease_id])

      if @lease.nil?
        redirect_to tenant_dashboard_index_path, alert: "Lease not found"
        return
      end

      @tenant = @lease.tenant
      @unit = @lease.unit

      @amount = if @lease.balance_due_cents.present?
                  @lease.balance_due_cents
                else
                  (@lease.rent_amount.to_f * 100).to_i
                end

      @razorpay_key_id = Rails.application.credentials.dig(:razorpay, :key_id)
    end

    def create_order
      lease = current_user.tenant.leases.find_by(id: params[:lease_id])

      if lease.nil?
        render json: { error: "Lease not found" }, status: :not_found
        return
      end

      amount_cents = params[:amount].to_i

      if amount_cents <= 0
        render json: { error: "Invalid amount" }, status: :unprocessable_entity
        return
      end

      Razorpay.setup(
        Rails.application.credentials.dig(:razorpay, :key_id),
        Rails.application.credentials.dig(:razorpay, :key_secret)
      )

      order = Razorpay::Order.create(
        amount: amount_cents,
        currency: "INR",
        receipt: "lease_#{lease.id}_#{Time.current.to_i}"
      )

      render json: {
        order_id: order.id,
        amount: amount_cents,
        currency: "INR",
        key_id: Rails.application.credentials.dig(:razorpay, :key_id)
      }
    end

    def verify
      lease = current_user.tenant.leases.find_by(id: params[:lease_id])

      if lease.nil?
        render json: { error: "Lease not found" }, status: :not_found
        return
      end

      generated_signature = OpenSSL::HMAC.hexdigest(
        "SHA256",
        Rails.application.credentials.dig(:razorpay, :key_secret),
        "#{params[:razorpay_order_id]}|#{params[:razorpay_payment_id]}"
      )

      if generated_signature != params[:razorpay_signature]
        render json: { error: "Payment verification failed" }, status: :unprocessable_entity
        return
      end

      amount_cents = params[:amount].to_i
      amount = amount_cents / 100.0
      payment = nil

      ActiveRecord::Base.transaction do
        payment = Payment.create!(
          tenant: current_user.tenant,
          lease: lease,
          amount: amount,
          payment_date: Date.current,
          status: :completed,
          transaction_id: params[:razorpay_payment_id]
        )

        old_balance = lease.balance_due_cents || (lease.rent_amount.to_f * 100).to_i
        new_balance = old_balance - amount_cents

        lease.update!(
          balance_due_cents: new_balance
        )
      end

      PaymentMailer.tenant_payment_success(payment).deliver_later
      PaymentMailer.owner_payment_received(payment).deliver_later

      render json: {
        success: true,
        redirect_url: tenant_dashboard_index_path
      }

    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def show
      if current_user.owner?
        @payment = Payment.joins(lease: :unit)
                          .where(units: { owner_id: current_user.id })
                          .find(params[:id])
      else
        @payment = current_user.tenant.payments.find(params[:id])
      end
    end
  end
end