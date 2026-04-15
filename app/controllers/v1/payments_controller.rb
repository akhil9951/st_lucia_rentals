module V1
    class PaymentsController < ApplicationController
      def new
        @payment = Payment.new
      end
  
      def create
        @payment = Payment.new(payment_params)
  
        if @payment.save
          redirect_to v1_lease_path(@payment.lease), notice: "Payment added"
        else
          render :new
        end
      end
  
      private
  
      def payment_params
        params.require(:payment).permit(:tenant_id, :lease_id, :amount, :payment_date, :status, :transaction_id)
      end
    end
end