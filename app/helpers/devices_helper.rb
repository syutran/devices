module DevicesHelper

  # 取设备版本变理event的名称
  def get_version_event(e)
    title=""
    case e
    when "update"
      title="信息变更"
    when "create"
      title="添加设备"
    else
      title="不明"
    end
    return title
  end

  # 取设备title的中文字
  def get_title(t)
    case t.downcase
    when "id"
      "ID"
    when "title"
      "名称"
    when "manufacturer"
      "厂商"
    when "seller"
      "经销商"
    when "dev_class"
      "类别"
    when "dev_model"
      "型号"
    when "serial_number"
      "序列号"
    when "parameter"
      "配置参数"
    when "purchased"
      "购置日期"
    when "used"
      "使用日期"
    when "description"
      "说明"
    when "status"
      "当前状态"
    when "user"
      "使用人"
    when "branch_id"
      "部门"
    when "avatar_file_name"
      "图片文件"
    when "tagboard_file_name"
      "标签文件"
    when "custom_file_name"
      "附件文件"
    else
      "notitle"
    end
  end

  def device_head_image_tag(device)
    if device.avatar.file?
      image_tag device.avatar.url(:head) ,class: "card-img-top", style: "width:100%;max-height:auto;background-size:cover;" 
    elsif device.category && device.category.avatar.file?
      image_tag device.category.avatar.url(:head) ,class: "card-img-top", style: "width:100%;max-height:auto;background-size:cover;" 
    else
      image_tag "/system/images/cards/device_head_01.jpg" ,class: "card-img-top", style: "width:100%;max-height:auto;background-size:cover;" 
    end
  end
end
