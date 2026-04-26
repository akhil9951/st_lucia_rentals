class Lease < ApplicationRecord
  include Payable
  belongs_to :tenant
  belongs_to :unit
  has_many :payments, dependent: :destroy

  validates :start_date, :rent_amount, presence: true
  before_validation :set_initial_balance_due_cents, on: :create

    # 💸 Calculate late fee
    def calculate_late_fee
      return 0 if due_date.nil?
      return 0 if due_date >= Date.today
  
      late_days = (Date.today - due_date).to_i
      late_days * 100   # ₹100 per day
    end

    private

    def set_initial_balance_due_cents
      self.balance_due_cents ||= (rent_amount.to_f * 100).to_i
    end
end

