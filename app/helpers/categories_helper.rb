module CategoriesHelper
  def get_grade_categories
    categories = Category.where(:master_id=>1,:group=>current_user.group).map { |m| [m.title, m.id] }
    categories << ["顶级分类",1]
  end

  def get_categories_collection
    Category.where("master_id != ? and categories.group = ?", 1, current_user.group).map { |r| [r.title, r.id]}
  end
  def category_head_image_tag(category)
    if category.avatar.file?
      image_tag category.avatar.url(:head) ,class: "card-img-top", style: "relative;width:100%;max-height:auto;background-size:cover;" 
    else
      image_tag "/system/images/cards/category_head_01.jpg" ,class: "card-img-top", style: "width:100%;max-height:auto;background-size:cover;" 
    end 
  end

  def get_class(key)
    Category.find(key)
  end

end
