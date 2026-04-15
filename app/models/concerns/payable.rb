module Payable
    extend ActiveSupport::Concern
  
    # ⚠️ Do NOT define has_many here unless ALL models need it
  
    def total_paid
      payments.where(status: :completed).sum(:amount)
    end
  
    def outstanding_amount
      rent_amount - total_paid
    end
  
    def fully_paid?
      outstanding_amount <= 0
    end
  end