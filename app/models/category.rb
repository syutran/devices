class Category < ApplicationRecord
  belongs_to :master, :class_name => "Category"
  has_many :subordinates, :class_name => "Category", :foreign_key => "master_id", :dependent => :restrict_with_error
  has_many :devices, :class_name => "Device", :foreign_key => "dev_class", :dependent => :restrict_with_error
  has_attached_file :avatar, styles: {head: "600x360#", medium: "300x200>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  #类的设备数
  def devices_all_count
    count = 0
    if !self.subordinates.blank?
      self.subordinates.each do |sub|
        count += sub.devices.count
      end
    else
      count = self.devices.count
    end
    return count
  end

end
