class AddAvatarColumnsToCategories < ActiveRecord::Migration[5.0]
  def change
    add_attachment :categories, :avatar
  end
end
