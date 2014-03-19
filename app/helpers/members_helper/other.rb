module MembersHelper
  module Other

    def disablePowerUp
      {
        power_up: data["value"]
      }
    end

    def enablePowerUp
      {
        power_up: data["value"]
      }
    end

    def memberJoinedTrello;
    end

    def updateMember;
    end

  end
end
