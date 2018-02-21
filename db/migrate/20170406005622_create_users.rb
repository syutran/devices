class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
        t.string :name
        t.string :email
        t.string :encrypted_password
        t.string :salt
        t.integer :grade
        t.integer :branch

      t.timestamps
    end
  end
end
