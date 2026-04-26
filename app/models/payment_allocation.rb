class PaymentAllocation < ApplicationRecord
  belongs_to :payment
  belongs_to :lease

  validates :amount_cents, numericality: { greater_than: 0 }
end
