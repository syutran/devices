class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :title
      t.string :manufacturer
      t.string :seller
      t.integer :dev_class
      t.string :dev_model
      t.string :serial_number
      t.text :parameter
      t.date :purchased
      t.date :used
      t.date :invalided
      t.integer :branch_id
      t.integer :custodian
      t.string :user
      t.string :status
      t.date :changed_date
      t.string :contacts
      t.text :description

      t.timestamps
    end
  end
end
