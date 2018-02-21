class Device < ApplicationRecord
    validates_presence_of :title, :branch_id, :dev_class, :dev_model
    belongs_to :branch, :class_name => "Branch"
    belongs_to :category, :class_name => "Category", :foreign_key => "dev_class"
    has_attached_file :avatar, styles: {original: "1024x1024>", head: "600x360#",medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing_device.png"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    has_attached_file :tagboard, styles: {original: "1024x1024>", head: "600x360#", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing_device.png"
    validates_attachment_content_type :tagboard, content_type: /\Aimage\/.*\z/
    has_attached_file :custom, styles: {original: "1024x1024>", head: "600x360#", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing_device.png"
    validates_attachment_content_type :custom, content_type: /\Aimage\/.*\z/
    has_paper_trail ignore: [:description,:created_at,:updated_at]
    paginates_per 20
    before_save do
      self.manufacturer = nil if self.manufacturer.blank?
      self.seller = nil if self.seller.blank?
      self.parameter = nil if self.parameter.blank?
      self.serial_number = nil if self.serial_number.blank?
      self.custodian = nil if self.custodian.blank?
      self.user = nil if self.user.blank?
      self.status = 1 if self.status.blank?
      self.contacts = nil if self.contacts.blank?
      self.description = nil if self.description.blank?
    end

    def sn
      self.group.to_s.rjust(6,'0') + self.id.to_s.rjust(8,'0')
    end

    def get_status
      case self.status
      when 0
        "领取待用"
      when 1
        "正常使用"
      when 2
        "离地维修"
      when 3
        "正在上交"
      when 4
        "新购入库"
      when 5
        "收回待用"
      when 6
        "正在下发"
      when 7
        "待报废"
      when 8
        "未标记"
      when 9
        "已报废处理"
      else
        "数据库空值"
      end
    end

    def set_status(status)
      self.status = status
    end
end
