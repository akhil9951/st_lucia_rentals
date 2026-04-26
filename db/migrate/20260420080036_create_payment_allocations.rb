class CreatePaymentAllocations < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_allocations do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :lease, null: false, foreign_key: true
      t.integer :amount_cents

      t.timestamps
    end
  end
end
