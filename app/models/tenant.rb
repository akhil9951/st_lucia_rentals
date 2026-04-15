# == Schema Information
# tenants
# id, name, email, phone, status, created_at
class Tenant < ApplicationRecord
    belongs_to :user, optional: true
    has_many :leases, dependent: :destroy
    has_many :units, through: :leases
    has_many :payments, dependent: :destroy
  
    enum status: { active: 0, inactive: 1 }
  
    validates :name, presence: true
  
    delegate :email, to: :user, allow_nil: true
end

