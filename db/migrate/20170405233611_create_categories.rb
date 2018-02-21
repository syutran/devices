class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :master_id
      t.text :description

      t.timestamps
    end
  end
end
