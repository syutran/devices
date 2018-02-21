class User < ApplicationRecord
  has_many :branches, :class_name => "Branch", :foreign_key => "manager_id"
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}, default_url: "/system/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil:true
  before_update :creator_grade
  after_initialize :init

  # 是否为超级管理员
  def is_admin
    if self.grade >= 9
      true
    else
      false
    end
  end

  # 是否为间谍
  def is_spy
    if self.grade == 7
      true
    else
      false
    end
  end

  # 是否为创建人
  def is_creator
     self.id == self.group
  end

  def init_branches
    branch = Branch.create(branch_id: self.group.to_s,branch: "系统部门", master_id: 1, group: self.id, manager_id: self.id, description: "这是个系统初始部门。创建的二级部门都隶属于这个部门，不要试图删除它或让它隶属于其它部门。")
    self.update(:branch => branch.id)
  end
  def init_categories
    Category.create(title: "大型设备", master_id: 1, group: self.id, description: "系统自动为您创建的顶级分类。")
    Category.create(title: "中型设备", master_id: 1, group: self.id, description: "系统自动为您创建的顶级分类。")
    Category.create(title: "小型设备", master_id: 1, group: self.id, description: "系统自动为您创建的顶级分类。")
    Category.create(title: "微型设备", master_id: 1, group: self.id, description: "系统自动为您创建的顶级分类。")
  end

  # 初始化用户等级值
  def init
    self.grade ||= 0
  end
  # 检查是否变更了创建人的级别
  def creator_grade
    if (self.id == self.group) && self.grade_changed?
      self.grade = self.grade_was
    end
  end

  # 用户所管理的部门名称
  def branches_name
    if self.is_admin
      Branch.where(group: self.group).first.root.branch
    elsif self.branches.length > 0
      self.branches.map {|m| m.branch}.join("&")
    else
      "未设置"
    end
  end

  # 用户的总部
  def root_branch
    Branch.where(group: self.group).first.root
  end

end
