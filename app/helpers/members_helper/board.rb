module MembersHelper
  module Board

    def addMemberToBoard
      {
        user_id: data["idMemberAdded"]
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

    def createList
      {
        list: data["list"]["name"]
      }
    end

    def deleteBoardInvitation;
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

    def makeObserverOfBoard;
    end

    def moveListFromBoard
      {
        list: data["list"]["name"],
        board_target: data["boardTarget"]["name"]
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

    def unconfirmedBoardInvitation;
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

  end
end
