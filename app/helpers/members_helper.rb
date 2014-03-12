module MembersHelper

  def action_describe(a)
    data = a[:data]
    opts =
      case a[:type].to_sym
        when :addAttachmentToCard
          {
            card: data["card"]["name"],
            attachment: data["attachment"]["name"],
            attachment_url: data["attachment"]["url"],
          }
        when :addChecklistToCard
          {
            card: data["card"]["name"],
            checklist: data["checklist"]["name"]
          }
        when :addMemberToBoard
          {
            user_id: data["idMemberAdded"]
          }
        when :addMemberToCard
          {
            card: data["card"]["name"],
            user: a[:member_participant]["fullName"]
          }
        when :addMemberToOrganization
          {
            organization: data["organization"]["name"],
            user_id: data["idMemberAdded"]
          }
        when :addToOrganizationBoard
          {
            organization: data["organization"]["name"],
            board: data["board"]["name"]
          }
        when :commentCard
          {
            card: data["card"]["name"],
            comment: data["text"]
          }
        when :copyCommentCard;
        when :convertToCardFromCheckItem
          {
            card: data["card"]["name"],
            card_source: data["cardSource"]["name"]
          }
        when :copyBoard
          {
            board_source: data["boardSource"]["name"],
            board: data["board"]["name"]
          }
        when :createBoard
          {
            board: data["board"]["name"]
          }
        when :createCard
          {
            card: data["card"]["name"],
            list: data["list"]["name"],
          }
        when :copyCard
          {
            card: data["card"]["name"],
            card_source: data["cardSource"]["name"],
            list: data["list"]["name"],
          }
        when :createList
          {
            list: data["list"]["name"]
          }
        when :createOrganization
          {
            organization: data["organization"]["name"]
          }
        when :deleteAttachmentFromCard
          {
            card: data["card"]["name"],
            attachment: data["attachment"]["name"]
          }
        when :deleteBoardInvitation;
        when :deleteCard
          {
            id_short: '#' + data["card"]["idShort"].to_s,
            list: data["list"]["name"]
          }
        when :deleteOrganizationInvitation;
        when :disablePowerUp
          {
            power_up: data["value"]
          }
        when :emailCard;
        when :enablePowerUp
          {
            power_up: data["value"]
          }
        when :makeAdminOfBoard
          {
            board: data["board"]["name"],
            user: a[:member_participant]["fullName"]
          }
        when :makeNormalMemberOfBoard
          {
            board: data["board"]["name"],
            user: a[:member_participant]["fullName"]
          }
        when :makeNormalMemberOfOrganization
          {
            organization: data["organization"]["name"],
            user: a[:member_participant]["fullName"]
          }
        when :makeObserverOfBoard;
        when :memberJoinedTrello;
        when :moveCardFromBoard
          {
            card: data["card"]["name"],
            board_target: data["boardTarget"]["name"]
          }
        when :moveListFromBoard
          {
            list: data["list"]["name"],
            board_target: data["boardTarget"]["name"]
          }
        when :moveCardToBoard
          {
            card: data["card"]["name"],
            board_source: data["boardSource"]["name"]
          }
        when :moveListToBoard
          {
            list: data["list"]["name"],
            board_source: data["boardSource"]["name"]
          }
        when :removeAdminFromBoard;
        when :removeAdminFromOrganization;
        when :removeChecklistFromCard
          {
            card: data["card"]["name"],
            checklist: data["checklist"]["name"]
          }
        when :removeFromOrganizationBoard;
        when :removeMemberFromCard
          {
            card: data["card"]["name"],
            user: a[:member_participant]["fullName"]
          }
        when :unconfirmedBoardInvitation;
        when :unconfirmedOrganizationInvitation;
        when :updateBoard
          if data["old"] && data["old"]["name"]
            {
              board_old: data["old"]["name"],
              type: :renamed
            }
          else
            {
              board: data["board"]["name"],
              type: :updated
            }
          end
        when :updateCard
          if data["listAfter"]
            {
              card: data["card"]["name"],
              list_after: data["listAfter"]["name"],
              list_before: data["listBefore"]["name"],
              type: "moved"
            }
          elsif data["card"].has_key? "closed"
            {
              card: data["card"]["name"],
              type: data["card"]["closed"] == true ? "archived" : "unarchived"
            }
          else
            {
              card: data["card"]["name"],
              type: :updated
            }
          end
        when :updateCheckItemStateOnCard
          {
            card: data["card"]["name"],
            type: data["checkItem"]["state"],
            check_item: data["checkItem"]["name"]
          }
        when :updateChecklist
          {
            checklist: data["checklist"]["name"],
            checklist_old: data["old"]["name"]
          }
        when :updateList
          if data["list"].has_key? "closed"
            {
              list: data["list"]["name"],
              type: data["list"]["closed"] == true ? "archived" : "unarchived"
            }
          else
            {
              list: data["list"]["name"],
              type: :updated
            }
          end
        when :updateMember;
        when :updateOrganization
          if data["old"]
            {
              organization: data["organization"]["name"],
              type: data["old"].keys.first
            }
          elsif data["organization"]["website"]
            {
              organization: data["organization"]["name"],
              type: :set_website
            }
          else
            {
              organization: data["organization"]["name"],
              type: :updated
            }
          end
      end

    if opts.present?
      t("members.activity.types.#{a[:type]}#{opts[:type] ? "_#{opts[:type]}" : ""}", wrap(opts))
    else
      a.inspect
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
