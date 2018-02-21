class AddGroupChangesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :group, :integer
  end
end
