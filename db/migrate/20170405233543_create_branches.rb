class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :branch_id
      t.string :branch
      t.integer :master_id
      t.text :description

      t.timestamps
    end
  end
end
