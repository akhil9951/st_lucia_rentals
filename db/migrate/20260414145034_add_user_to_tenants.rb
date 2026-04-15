class AddUserToTenants < ActiveRecord::Migration[7.1]
  def change
    add_reference :tenants, :user, null: true, foreign_key: true
  end
end
