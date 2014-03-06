module ApplicationHelper
  def js_void
    return "javascript:void(0);"
  end

  def user_avatar(member, size = :small)
     if member.avatar_id
       image_tag member.avatar_url({ size: size })
     else
       image_tag "avatar_#{size}.png"
     end
  end
end
