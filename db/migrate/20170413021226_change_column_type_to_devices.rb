class ChangeColumnTypeToDevices < ActiveRecord::Migration[5.0]
  def change
    change_column :devices, :status, :integer
  end
end
