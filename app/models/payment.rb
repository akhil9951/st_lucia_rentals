# payments table
# id, tenant_id, amount, payment_date, status

class Payment < ApplicationRecord
  belongs_to :lease
  belongs_to :tenant
  belongs_to :unit, optional: true
  has_many :payment_allocations, dependent: :destroy

  validates :amount, presence: true, numericality: { greater_than: 0 }

  enum status: { pending: 0, completed: 1, failed: 2 }
end