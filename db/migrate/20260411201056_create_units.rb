class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :name
      t.decimal :rent_amount
      t.integer :status

      t.timestamps
    end
  end
end
