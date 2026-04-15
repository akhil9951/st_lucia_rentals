# units table
# id, name, rent_amount, due_date, tenant_id, status

class Unit < ApplicationRecord
  has_many :leases, dependent: :destroy
  has_many :tenants, through: :leases   # 🔥 THIS FIXES YOUR ERROR

  validates :name, :rent_amount, presence: true

  enum status: { vacant: 0, occupied: 1 }
end
