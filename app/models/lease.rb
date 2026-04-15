class Lease < ApplicationRecord
  include Payable
  belongs_to :tenant
  belongs_to :unit

  has_many :payments, dependent: :destroy

  validates :start_date, :rent_amount, presence: true
end

