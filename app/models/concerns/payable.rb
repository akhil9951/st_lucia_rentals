# app/models/concerns/payable.rb

module Payable
  extend ActiveSupport::Concern

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