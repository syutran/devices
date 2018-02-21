class AddGroupToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :group, :integer
  end
end
