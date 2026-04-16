class RentMailer < ApplicationMailer
    def rent_reminder(tenant, lease)
      @tenant = tenant
      @lease = lease
  
      mail(
        to: @tenant.user.email,
        subject: "Rent Due Reminder 💰"
      )
    end
  end