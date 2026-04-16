class AddLateFeeToLeases < ActiveRecord::Migration[7.1]
  def change
    add_column :leases, :late_fee, :decimal
  end
end
