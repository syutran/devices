class AddAncestryToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :ancestry, :string
    add_index :branches, :ancestry
  end
end
