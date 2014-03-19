module MembersHelper
  module Actions
    class << self

      def addAttachmentToCard(data)
        {
          card: data[:data]["card"]["name"],
          attachment: data[:data]["attachment"]["name"],
          attachment_url: data[:data]["attachment"]["url"],
        }
      end

      def addChecklistToCard(data)
        {
          card: data[:data]["card"]["name"],
          checklist: data[:data]["checklist"]["name"]
        }
      end

      def addMemberToBoard(data)
        {
          user_id: data[:data]["idMemberAdded"]
        }
      end

      def addMemberToCard(data)
        {
          card: data[:data]["card"]["name"],
          user: data[:member_participant]["fullName"]
        }
      end

      def addMemberToOrganization(data)
        {
          organization: data[:data]["organization"]["name"],
          user_id: data[:data]["idMemberAdded"]
        }
      end

      def addToOrganizationBoard(data)
        {
          organization: data[:data]["organization"]["name"],
          board: data[:data]["board"]["name"]
        }
      end

      def commentCard(data)
        {
          card: data[:data]["card"]["name"],
          comment: data[:data]["text"]
        }
      end

      def copyCommentCard;
      end

      def convertToCardFromCheckItem(data)
        {
          card: data[:data]["card"]["name"],
          card_source: data[:data]["cardSource"]["name"]
        }
      end

      def copyBoard(data)
        {
          board_source: data[:data]["boardSource"]["name"],
          board: data[:data]["board"]["name"]
        }
      end

      def createBoard(data)
        {
          board: data[:data]["board"]["name"]
        }
      end

      def createCard(data)
        {
          card: data[:data]["card"]["name"],
          list: data[:data]["list"]["name"],
        }
      end

      def copyCard(data)
        {
          card: data[:data]["card"]["name"],
          card_source: data[:data]["cardSource"]["name"],
          list: data[:data]["list"]["name"],
        }
      end

      def createList(data)
        {
          list: data[:data]["list"]["name"]
        }
      end

      def createOrganization(data)
        {
          organization: data[:data]["organization"]["name"]
        }
      end

      def deleteAttachmentFromCard(data)
        {
          card: data[:data]["card"]["name"],
          attachment: data[:data]["attachment"]["name"]
        }
      end

      def deleteBoardInvitation;
      end

      def deleteCard(data)
        {
          id_short: '#' + data[:data]["card"]["idShort"].to_s,
          list: data[:data]["list"]["name"]
        }
      end

      def deleteOrganizationInvitation;
      end

      def disablePowerUp(data)
        {
          power_up: data[:data]["value"]
        }
      end

      def emailCard;
      end

      def enablePowerUp(data)
        {
          power_up: data[:data]["value"]
        }
      end

      def makeAdminOfBoard(data)
        {
          board: data[:data]["board"]["name"],
          user: data[:member_participant]["fullName"]
        }
      end

      def makeNormalMemberOfBoard(data)
        {
          board: data[:data]["board"]["name"],
          user: data[:member_participant]["fullName"]
        }
      end

      def makeNormalMemberOfOrganization(data)
        {
          organization: data[:data]["organization"]["name"],
          user: data[:member_participant]["fullName"]
        }
      end

      def makeObserverOfBoard;
      end

      def memberJoinedTrello;
      end

      def moveCardFromBoard(data)
        {
          card: data[:data]["card"]["name"],
          board_target: data[:data]["boardTarget"]["name"]
        }
      end

      def moveListFromBoard(data)
        {
          list: data[:data]["list"]["name"],
          board_target: data[:data]["boardTarget"]["name"]
        }
      end

      def moveCardToBoard(data)
        {
          card: data[:data]["card"]["name"],
          board_source: data[:data]["boardSource"]["name"]
        }
      end

      def moveListToBoard(data)
        {
          list: data[:data]["list"]["name"],
          board_source: data[:data]["boardSource"]["name"]
        }
      end

      def removeAdminFromBoard;
      end

      def removeAdminFromOrganization;
      end

      def removeChecklistFromCard(data)
        {
          card: data[:data]["card"]["name"],
          checklist: data[:data]["checklist"]["name"]
        }
      end

      def removeFromOrganizationBoard;
      end

      def removeMemberFromCard(data)
        {
          card: data[:data]["card"]["name"],
          user: data[:member_participant]["fullName"]
        }
      end

      def unconfirmedBoardInvitation;
      end

      def unconfirmedOrganizationInvitation;
      end

      def updateBoard(data)
        if data[:data]["old"] && data[:data]["old"]["name"]
          {
            board_old: data[:data]["old"]["name"],
            type: :renamed
          }
        else
          {
            board: data[:data]["board"]["name"],
            type: :updated
          }
        end
      end

      # support func
      def updateCard_list_changed(data)
        {
          card: data[:data]["card"]["name"],
          list_after: data[:data]["listAfter"]["name"],
          list_before: data[:data]["listBefore"]["name"],
          type: "moved"
        }
      end

      # support func
      def updateCard_card_closed(data)
        {
          card: data[:data]["card"]["name"],
          type: data[:data]["card"]["closed"] == true ? "archived" : "unarchived"
        }
      end

      # support func
      def updateCard_pos_changed(data)
        if (data[:data]["old"]["pos"] > data[:data]["card"]["pos"])
          {
            card: data[:data]["card"]["name"],
            type:  :moved_up
          }
        else
          {
            card: data[:data]["card"]["name"],
            type: :moved_down
          }
        end
      end

      def updateCard(data)
        card = data[:data]
        return updateCard_list_changed(data) if card["listAfter"]
        return updateCard_card_closed(data)  if card["card"].has_key?("closed")
        return updateCard_pos_changed(data)  if card["old"] && card["old"].has_key?("pos")
        { card: card["card"]["name"], type: :updated }
      end

      def updateCheckItemStateOnCard(data)
        {
          card: data[:data]["card"]["name"],
          type: data[:data]["checkItem"]["state"],
          check_item: data[:data]["checkItem"]["name"]
        }
      end

      def updateChecklist(data)
        {
          checklist: data[:data]["checklist"]["name"],
          checklist_old: data[:data]["old"]["name"]
        }
      end

      def updateList(data)
        if data[:data]["list"].has_key? "closed"
          {
            list: data[:data]["list"]["name"],
            type: data[:data]["list"]["closed"] == true ? "archived" : "unarchived"
          }
        else
          {
            list: data[:data]["list"]["name"],
            type: :updated
          }
        end
      end

      def updateMember(data);
      end

      def updateOrganization(data)
        if data[:data]["old"]
          {
            organization: data[:data]["organization"]["name"],
            type: data[:data]["old"].keys.first
          }
        elsif data[:data]["organization"]["website"]
          {
            organization: data[:data]["organization"]["name"],
            type: :set_website
          }
        else
          {
            organization: data[:data]["organization"]["name"],
            type: :updated
          }
        end
      end
    end
  end
end
