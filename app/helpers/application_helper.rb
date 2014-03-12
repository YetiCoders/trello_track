module ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper

  def js_void
    return "javascript:void(0);"
  end

  def js_html(selector, *options)
    if options.first.is_a?(Hash)
      js_action = options.first.delete(:js_action) || "html"
    end

    js_action ||= "html"

    text = options.first.is_a?(Hash) ? render_to_string(*options) : options.first

    <<JS
$('#{selector}').#{js_action}('#{escape_javascript(text)}');
JS
  end

  def user_avatar(member, size = :small)
     if member.avatar_id
       image_tag member.avatar_url({ size: size })
     else
       image_tag "avatar_#{size}.png"
     end
  end

  def fetch_member(member_id)
    Rails.cache.fetch("member-#{member_id}", expires_in: 10.minutes) do
      trello_client.find(:member, member_id)
    end
  end
end
