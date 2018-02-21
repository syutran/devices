class Branch < ApplicationRecord
  validates_presence_of :branch, :branch_id
  belongs_to :master, :class_name => "Branch"
  belongs_to :manager, :class_name => "User", optional: true
  has_many :branches, :class_name => "Branch", :foreign_key => "master_id", :dependent => :restrict_with_error
  has_many :devices, :class_name => "Device", :dependent => :restrict_with_error
  has_ancestry

  def get_manager
    User.where(:branch=>self.id).last
  end
end
