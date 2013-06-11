module PostsHelper
  
  def indentation_by_level(post)
    "margin-left: #{post.path.count('.') * 10 }px"
  end
  
end
