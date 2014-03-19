module MembersHelper
  module Card

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

    def addMemberToCard
      {
        card: card_name,
        user: participant["fullName"]
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

    def deleteAttachmentFromCard
      {
        card: card_name,
        attachment: data["attachment"]["name"]
      }
    end

    def deleteCard
      {
        id_short: '#' + data["card"]["idShort"].to_s,
        list: data["list"]["name"]
      }
    end

    def emailCard;
    end

    def moveCardFromBoard
      {
        card: card_name,
        board_target: data["boardTarget"]["name"]
      }
    end

    def moveCardToBoard
      {
        card: card_name,
        board_source: data["boardSource"]["name"]
      }
    end

    def removeMemberFromCard
      {
        card: card_name,
        user: participant["fullName"]
      }
    end

  end
end
