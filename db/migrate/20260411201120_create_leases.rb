class CreateLeases < ActiveRecord::Migration[7.1]
  def change
    create_table :leases do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :rent_amount
      t.date :due_date
      t.integer :status

      t.timestamps
    end
  end
end
