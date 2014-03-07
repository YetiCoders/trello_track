module MembersHelper
  def action_describe(a)
    opts = case a[:type].to_sym
    when :addMemberToCard
      # TODO remove card(), user() calls
      { card: card(a[:data]["card"]["name"]), :user => user(a[:data]["card"]["id"])}
    when :createOrganizationa
      { name: a[:data]["organization"]["name"] }
    when :updateCard
      {}
    else
      {}
    end

    if opts.present?
      t("members.activity.types.#{a[:type]}", wrap(opts))
    else
      a.inspect
    end
  end

  protected

  # TODO
  # Need helper for wrap hash as:
  # wrap({ 'key' => :value }) -> "\"<span class='key'>value</span>\""
  def wrap(hash)
    hash
  end

  def user(id)
    "<span class='user'>#{id}</span>"
  end

  def card(name)
    "<span class='card'>#{name}</span>"
  end
end
