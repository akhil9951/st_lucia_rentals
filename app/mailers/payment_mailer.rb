class PaymentMailer < ApplicationMailer
    default from: "thalamalaakhil@gmail.com"
  
    def tenant_payment_success(payment)
      @payment = payment
      @tenant = payment.tenant
      @lease = payment.lease
      @unit = @lease.unit
  
      mail(
        to: @tenant.email,
        subject: "Rent Payment Successful"
      )
    end
  
    def owner_payment_received(payment)
      @payment = payment
      @tenant = payment.tenant
      @lease = payment.lease
      @unit = @lease.unit
      @owner = @unit.owner
  
      mail(
        to: @owner.email,
        subject: "Rent Payment Received"
      )
    end
  end