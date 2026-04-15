class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :lease, null: false, foreign_key: true
      t.decimal :amount
      t.date :payment_date
      t.integer :status
      t.string :transaction_id

      t.timestamps
    end
  end
end
