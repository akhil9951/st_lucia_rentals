class AddOwnerToUnits < ActiveRecord::Migration[7.1]
  def change
    add_reference :units, :owner, foreign_key: { to_table: :users }
  end
end
