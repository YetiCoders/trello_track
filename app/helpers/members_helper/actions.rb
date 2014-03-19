module MembersHelper
  class Actions

    def initialize(action)
      @action = action
    end

    attr_reader :action

    def data
      action[:data]
    end

    def card_name
      data["card"]["name"]
    end

    def organization_name
      data["organization"]["name"]
    end

    def participant
      action[:member_participant]
    end

    def addAttachmentToCard
      {
        card: card_name,
        attachment: data["attachment"]["name"],
        attachment_url: data["attachment"]["url"],
      }
    end

    def addChecklistToCard
      {
        card: card_name,
        checklist: data["checklist"]["name"]
      }
    end

    def addMemberToBoard
      {
        user_id: data["idMemberAdded"]
      }
    end

    def addMemberToCard
      {
        card: card_name,
        user: participant["fullName"]
      }
    end

    def addMemberToOrganization
      {
        organization: organization_name,
        user_id: data["idMemberAdded"]
      }
    end

    def addToOrganizationBoard
      {
        organization: organization_name,
        board: data["board"]["name"]
      }
    end

    def commentCard
      {
        card: card_name,
        comment: data["text"]
      }
    end

    def copyCommentCard;
    end

    def convertToCardFromCheckItem
      {
        card: card_name,
        card_source: data["cardSource"]["name"]
      }
    end

    def copyBoard
      {
        board_source: data["boardSource"]["name"],
        board: data["board"]["name"]
      }
    end

    def createBoard
      {
        board: data["board"]["name"]
      }
    end

    def createCard
      {
        card: card_name,
        list: data["list"]["name"],
      }
    end

    def copyCard
      {
        card: card_name,
        card_source: data["cardSource"]["name"],
        list: data["list"]["name"],
      }
    end

    def createList
      {
        list: data["list"]["name"]
      }
    end

    def createOrganization
      {
        organization: organization_name
      }
    end

    def deleteAttachmentFromCard
      {
        card: card_name,
        attachment: data["attachment"]["name"]
      }
    end

    def deleteBoardInvitation;
    end

    def deleteCard
      {
        id_short: '#' + data["card"]["idShort"].to_s,
        list: data["list"]["name"]
      }
    end

    def deleteOrganizationInvitation;
    end

    def disablePowerUp
      {
        power_up: data["value"]
      }
    end

    def emailCard;
    end

    def enablePowerUp
      {
        power_up: data["value"]
      }
    end

    def makeAdminOfBoard
      {
        board: data["board"]["name"],
        user: participant["fullName"]
      }
    end

    def makeNormalMemberOfBoard
      {
        board: data["board"]["name"],
        user: participant["fullName"]
      }
    end

    def makeNormalMemberOfOrganization
      {
        organization: organization_name,
        user: participant["fullName"]
      }
    end

    def makeObserverOfBoard;
    end

    def memberJoinedTrello;
    end

    def moveCardFromBoard
      {
        card: card_name,
        board_target: data["boardTarget"]["name"]
      }
    end

    def moveListFromBoard
      {
        list: data["list"]["name"],
        board_target: data["boardTarget"]["name"]
      }
    end

    def moveCardToBoard
      {
        card: card_name,
        board_source: data["boardSource"]["name"]
      }
    end

    def moveListToBoard
      {
        list: data["list"]["name"],
        board_source: data["boardSource"]["name"]
      }
    end

    def removeAdminFromBoard;
    end

    def removeAdminFromOrganization;
    end

    def removeChecklistFromCard
      {
        card: card_name,
        checklist: data["checklist"]["name"]
      }
    end

    def removeFromOrganizationBoard;
    end

    def removeMemberFromCard
      {
        card: card_name,
        user: participant["fullName"]
      }
    end

    def unconfirmedBoardInvitation;
    end

    def unconfirmedOrganizationInvitation;
    end

    def updateBoard
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
    end

    # support func
    def updateCard_list_changed
      {
        card: card_name,
        list_after: data["listAfter"]["name"],
        list_before: data["listBefore"]["name"],
        type: "moved"
      }
    end

    # support func
    def updateCard_card_closed
      {
        card: card_name,
        type: data["card"]["closed"] == true ? "archived" : "unarchived"
      }
    end

    # support func
    def updateCard_pos_changed
      if (data["old"]["pos"] > data["card"]["pos"])
        {
          card: card_name,
          type:  :moved_up
        }
      else
        {
          card: card_name,
          type: :moved_down
        }
      end
    end

    def updateCard
      card = data
      return updateCard_list_changed if card["listAfter"]
      return updateCard_card_closed  if card["card"].has_key?("closed")
      return updateCard_pos_changed  if card["old"] && card["old"].has_key?("pos")
      { card: card["card"]["name"], type: :updated }
    end

    def updateCheckItemStateOnCard
      {
        card: card_name,
        type: data["checkItem"]["state"],
        check_item: data["checkItem"]["name"]
      }
    end

    def updateChecklist
      {
        checklist: data["checklist"]["name"],
        checklist_old: data["old"]["name"]
      }
    end

    def updateList
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
    end

    def updateMember;
    end

    # support func
    def updateOrganization_name
      {
        organization: organization_name,
        type: data["old"].keys.first
      }
    end

    # support func
    def updateOrganization_website
      {
        organization: organization_name,
        type: :set_website
      }
    end

    def updateOrganization
      return updateOrganization_name if data["old"]
      return updateOrganization_website if data["organization"]["website"]
      {
        organization: organization_name,
        type: :updated
      }
    end

  end
end
