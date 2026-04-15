class CreateTenants < ActiveRecord::Migration[7.1]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.integer :status

      t.timestamps
    end
  end
end
