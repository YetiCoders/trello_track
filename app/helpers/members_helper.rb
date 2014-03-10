module MembersHelper

  def action_describe(a)
    opts =
      case a[:type].to_sym
        when :addAttachmentToCard
          {
            card: a[:data]["card"]["name"],
            attachment: a[:data]["attachment"]["name"],
            attachment_url: a[:data]["attachment"]["url"],
          }
        when :addChecklistToCard
          {
            card: a[:data]["card"]["name"],
            checklist: a[:data]["checklist"]["name"]
          }
        when :addMemberToBoard;
        when :addMemberToCard
          {
            card: a[:data]["card"]["name"],
            user: a[:data]["card"]["id"]
          }
        when :addMemberToOrganization;
        when :addToOrganizationBoard;
        when :commentCard
          {
            card: a[:data]["card"]["name"],
            comment: a[:data]["text"]
          }
        when :copyCommentCard;
        when :convertToCardFromCheckItem;
        when :copyBoard;
        when :createBoard;
        when :createCard
          {
            card: a[:data]["card"]["name"],
            list: a[:data]["list"]["name"],
          }
        when :copyCard
          {
            card: a[:data]["card"]["name"],
            card_source: a[:data]["cardSource"]["name"],
            list: a[:data]["list"]["name"],
          }
        when :createList
          {
            list: a[:data]["list"]["name"]
          }
        when :createOrganization
          { orgname: a[:data]["organization"]["name"] }
        when :deleteAttachmentFromCard
          {
            card: a[:data]["card"]["name"],
            attachment: a[:data]["attachment"]["name"]
          }
        when :deleteBoardInvitation;
        when :deleteCard
          {
            id_short: '#' + a[:data]["card"]["idShort"].to_s,
            list: a[:data]["list"]["name"]
          }
        when :deleteOrganizationInvitation;
        when :disablePowerUp;
        when :emailCard;
        when :enablePowerUp;
        when :makeAdminOfBoard;
        when :makeNormalMemberOfBoard;
        when :makeNormalMemberOfOrganization;
        when :makeObserverOfBoard;
        when :memberJoinedTrello;
        when :moveCardFromBoard
          {
            card: a[:data]["card"]["name"],
            board_target: a[:data]["boardTarget"]["name"]
          }
        when :moveListFromBoard
          {
            list: a[:data]["list"]["name"],
            board_target: a[:data]["boardTarget"]["name"]
          }
        when :moveCardToBoard
          {
            card: a[:data]["card"]["name"],
            board_source: a[:data]["boardSource"]["name"]
          }
        when :moveListToBoard
          {
            list: a[:data]["list"]["name"],
            board_source: a[:data]["boardSource"]["name"]
          }
        when :removeAdminFromBoard;
        when :removeAdminFromOrganization;
        when :removeChecklistFromCard
          {
            card: a[:data]["card"]["name"],
            checklist: a[:data]["checklist"]["name"]
          }
        when :removeFromOrganizationBoard;
        when :removeMemberFromCard
          {
            card: a[:data]["card"]["name"],
            user: a[:data]["card"]["id"]
          }
        when :unconfirmedBoardInvitation;
        when :unconfirmedOrganizationInvitation;
        when :updateBoard;
        when :updateCard
          if a[:data]["listAfter"]
            {
              card: a[:data]["card"]["name"],
              list_after: a[:data]["listAfter"]["name"],
              list_before: a[:data]["listBefore"]["name"],
              type: "moved"
            }
          elsif a[:data]["card"].has_key? "closed"
            {
              card: a[:data]["card"]["name"],
              type: a[:data]["card"]["closed"] == true ? "archived" : "unarchived"
            }
          else
            {
              card: a[:data]["card"]["name"],
              type: "updated"
            }
          end
        when :updateCheckItemStateOnCard
          {
            card: a[:data]["card"]["name"],
            type: a[:data]["checkItem"]["state"],
            check_item: a[:data]["checkItem"]["name"]
          }
        when :updateChecklist
          {
            checklist: a[:data]["checklist"]["name"],
            checklist_old: a[:data]["old"]["name"]
          }
        when :updateList
          if a[:data]["list"].has_key? "closed"
            {
              list: a[:data]["list"]["name"],
              type: a[:data]["list"]["closed"] == true ? "archived" : "unarchived"
            }
          else
            {
              list: a[:data]["list"]["name"],
              type: "updated"
            }
          end
        when :updateMember;
        when :updateOrganization;
      end

    if opts.present?
      Rails.logger.debug opts.inspect
      Rails.logger.debug "members.activity.types.#{a[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}"
      t("members.activity.types.#{a[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}", wrap(opts))
    else
      a.inspect
    end
  end

  def username(hash)
    #TODO this method should extract username by id from cached data.
    # It should consider 'you' user
    hash[:user]
  end

  def attachment(hash)
    return link_to hash[:attachment], hash[:attachment_url], target: "_blank" if hash[:attachment_url]
    hash[:attachment]
  end

  protected

  # Wrap hash values into span with class correspond key and escape html
  def wrap(hash)
    hash[:user] = username(hash) if hash[:user]
    hash[:attachment] = attachment(hash) if hash[:attachment]
    hash.merge(hash){|key, value| "<span class=\"#{key}\">#{h value}</span>"}
  end

end
