module MembersHelper

  def action_describe(action)
    opts = Actions.new(action).send(action[:type])

    if opts.present?
      t("members.activity.types.#{action[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}", wrap(opts))
    else
      # send email to developers with hash
      UserMailer::no_action_email(action)
      action[:type]
    end
  end

  def username(hash)
    #TODO this method should extract username by id from cached data.
    @members[hash[:user_id]].full_name
  end

  def attachment(hash)
    return link_to hash[:attachment], hash[:attachment_url], target: "_blank" if hash[:attachment_url]
    hash[:attachment]
  end

  protected

  # Wrap hash values into span with class correspond key and escape html
  def wrap(hash)
    hash[:user] = username(hash) if hash[:user_id]
    hash[:attachment] = attachment(hash) if hash[:attachment]
    hash.merge(hash){|key, value| "<span class=\"#{key}\">#{h value}</span>"}
  end

end
