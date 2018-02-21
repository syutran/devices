class AddAvatarColumnsToDevices < ActiveRecord::Migration[5.0]
  def change
    add_attachment :devices, :avatar
    add_attachment :devices, :tagboard
    add_attachment :devices, :custom
  end
end
