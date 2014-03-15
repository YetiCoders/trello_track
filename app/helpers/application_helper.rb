module ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper

  def flash_html
    html = []

    flash.to_hash.each do |type, messages|
      messages = Array(messages).join "<br />"
      type = "danger" if type == :error
      html << content_tag(:div, class: "alert alert-dismissable alert-#{type}") do
        concat content_tag(:div, "&times;".html_safe, class: :close, "data-dismiss" => "alert", "aria-hidden" => "true")
        concat messages
      end
    end

    flash.discard
    html.join("\n").html_safe
  end

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

  def fetch_member(member_id, force = false)
    Rails.cache.fetch("member-#{member_id}", expires_in: 10.minutes, force: force) do
      trello_client.find(:member, member_id)
    end
  end
end
