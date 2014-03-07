module MembersHelper

  def action_describe(a)
    opts =
      case a[:type].to_sym
      when :addAttachmentToCard;
      when :addChecklistToCard;
      when :addMemberToBoard;
      when :addMemberToCard
        { card: a[:data]["card"]["name"],
          user: a[:data]["card"]["id"] }
      when :addMemberToOrganization;
      when :addToOrganizationBoard;
      when :commentCard;
      when :copyCommentCard;
      when :convertToCardFromCheckItem;
      when :copyBoard;
      when :createBoard;
      when :createCard;
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
      when :removeMemberFromCard;
      when :unconfirmedBoardInvitation;
      when :unconfirmedOrganizationInvitation;
      when :updateBoard;
      when :updateCard;
      when :updateCheckItemStateOnCard;
      when :updateChecklist;
      when :updateList;
      when :updateMember;
      when :updateOrganization;
      when :updateCard;
      when :updateList;
      end

    if opts.present?
      t("members.activity.types.#{a[:type]}", wrap(opts))
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
