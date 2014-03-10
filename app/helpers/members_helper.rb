module MembersHelper

  def action_describe(a)
    opts =
      case a[:type].to_sym
        when :addAttachmentToCard;
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
        when :commentCard;
        when :copyCommentCard;
        when :convertToCardFromCheckItem;
        when :copyBoard;
        when :createBoard;
        when :createCard
          {
            card: a[:data]["card"]["name"],
            list: a[:data]["list"]["name"],
          }
        when :copyCard;
        when :createList;
        when :createOrganization
          { orgname: a[:data]["organization"]["name"] }
        when :deleteAttachmentFromCard;
        when :deleteBoardInvitation;
        when :deleteCard;
        when :deleteOrganizationInvitation;
        when :disablePowerUp;
        when :emailCard;
        when :enablePowerUp;
        when :makeAdminOfBoard;
        when :makeNormalMemberOfBoard;
        when :makeNormalMemberOfOrganization;
        when :makeObserverOfBoard;
        when :memberJoinedTrello;
        when :moveCardFromBoard;
        when :moveListFromBoard;
        when :moveCardToBoard;
        when :moveListToBoard;
        when :removeAdminFromBoard;
        when :removeAdminFromOrganization;
        when :removeChecklistFromCard;
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
          else
            {
              card: a[:data]["card"]["name"],
              type: "updated"
            }
          end
        when :updateCheckItemStateOnCard
          {
            card: a[:data]["card"]["name"],
            state: a[:data]["checkItem"]["state"] + "d",
            check_item: a[:data]["checkItem"]["name"]
          }
        when :updateChecklist
          {
            checklist: a[:data]["checklist"]["name"],
            checklist_old: a[:data]["old"]["name"]
          }
        when :updateList;
        when :updateMember;
        when :updateOrganization;
        when :updateCard;
        when :updateList;
      end

    if opts.present?
      Rails.logger.debug opts.inspect
      Rails.logger.debug "members.activity.types.#{a[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}"
      t("members.activity.types.#{a[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}", wrap(opts))
    else
      a.inspect
    end
  end

  def username(id)
    #TODO this method should extract username by id from cached data.
    # It should consider 'you' user
    id
  end

  protected

  # Wrap hash values into span with class correspond key and escape html
  def wrap(hash)
    hash[:user] = username(hash[:user]) if hash[:user]
    hash.merge(hash){|key, value| "<span class=\"#{key}\">#{h value}</span>"}
  end

end
