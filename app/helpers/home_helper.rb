module HomeHelper
  def username_with_avatar(member)
    content_tag(:div, image_tag(member.avatar_url({ size: :small })), class: "avatar pull-left") +
    content_tag(:div, member.full_name, class: :name)
  end
end
