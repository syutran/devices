class AddGroupToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :group, :integer
  end
end
