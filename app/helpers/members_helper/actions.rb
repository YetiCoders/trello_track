module MembersHelper
  class Actions

    include Board
    include Card
    include Organization
    include Other
    include UpdateCard

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

  end
end
