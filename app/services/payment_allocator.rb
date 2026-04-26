class PaymentAllocator
    Result = Struct.new(:applied, :remaining_cents, :allocations, keyword_init: true)
  
    def initialize(leases:, payment_cents:)
      @leases = leases
      @payment_cents = payment_cents.to_i
    end
  
    def call
      remaining = payment_cents
      allocations = []
  
      sorted_leases = leases.sort_by { |lease| [lease.due_date || Date.current, lease.unit_id || 0] }
  
      # Step 1: fully pay what can be fully covered
      sorted_leases.each do |lease|
        balance = lease.balance_due_cents.to_i
        next if balance <= 0
  
        if remaining >= balance
          allocations << { lease: lease, amount_cents: balance, kind: :full }
          remaining -= balance
        end
      end
  
      # Step 2: partial pay next unpaid lease
      if remaining > 0
        next_lease = sorted_leases.find do |lease|
          balance = lease.balance_due_cents.to_i
          already_allocated = allocations.any? { |a| a[:lease].id == lease.id }
          balance > 0 && !already_allocated
        end
  
        if next_lease
          allocations << { lease: next_lease, amount_cents: remaining, kind: :partial }
          remaining = 0
        end
      end
  
      # Step 3: overpayment
      if remaining > 0
        target_lease = sorted_leases.last
        if target_lease
          allocations << { lease: target_lease, amount_cents: remaining, kind: :overpay }
          remaining = 0
        end
      end
  
      apply_allocations!(allocations)
  
      Result.new(
        applied: payment_cents - remaining,
        remaining_cents: remaining,
        allocations: allocations
      )
    end
  
    private
  
    attr_reader :leases, :payment_cents
  
    def apply_allocations!(allocations)
      allocations.each do |entry|
        lease = entry[:lease]
        amount = entry[:amount_cents]
  
        new_balance = lease.balance_due_cents.to_i - amount
        lease.update!(balance_due_cents: new_balance)
      end
    end
  end