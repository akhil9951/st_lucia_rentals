class AddOwnerToTenants < ActiveRecord::Migration[7.1]
  def change
    add_reference :tenants, :owner, foreign_key: { to_table: :users }
  end
end
