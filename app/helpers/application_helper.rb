module ApplicationHelper
  def head_title(title)
    content_for(:head_title) { title }
  end
end
