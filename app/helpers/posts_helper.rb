module PostsHelper
  
  def indentation_by_level(post)
    "margin-left: #{(post.path.count('.') - 1) * 10 }px"
  end
  
  def blur_censored(text)
    raw sanitize(text).gsub /\b(x{3,})\b/im, '<span class="censored_world">\1</span>'
  end
  
end
