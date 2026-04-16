class RentReminderService
  def self.send_reminders
    puts "🔔 Running rent reminder job..."

    Lease.find_each do |lease|
      tenant = lease.tenant
      next unless tenant&.user

      due_date = lease.due_date
      today = Date.today

      # 💸 Calculate late fee
      late_fee = lease.calculate_late_fee

      # Save it
      lease.update(late_fee: late_fee)

      if due_date == today + 3
        RentMailer.rent_reminder(tenant, lease).deliver_now
        puts "📩 Reminder sent (before due)"
      end

      if due_date == today
        RentMailer.rent_reminder(tenant, lease).deliver_now
        puts "📧 Due today mail sent"
      end

      if due_date < today
        RentMailer.rent_reminder(tenant, lease).deliver_now
        puts "⚠️ Overdue mail sent (Late fee: ₹#{late_fee})"
      end
    end
  end
end