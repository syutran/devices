class AddGroupToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :group, :integer
  end
end
