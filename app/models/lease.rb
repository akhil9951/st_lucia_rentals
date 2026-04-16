class Lease < ApplicationRecord
  include Payable
  belongs_to :tenant
  belongs_to :unit

  has_many :payments, dependent: :destroy

  validates :start_date, :rent_amount, presence: true

    # 💸 Calculate late fee
    def calculate_late_fee
      return 0 if due_date.nil?
      return 0 if due_date >= Date.today
  
      late_days = (Date.today - due_date).to_i
      late_days * 100   # ₹100 per day
    end
end

