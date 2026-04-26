class AddBalanceDueCentsToLeases < ActiveRecord::Migration[7.1]
  def change
    add_column :leases, :balance_due_cents, :integer
  end
end
