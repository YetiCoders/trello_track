module MembersHelper
  module UpdateCard

    def removeChecklistFromCard
      {
        card: card_name,
        checklist: data["checklist"]["name"]
      }
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


    protected
    def updateCard_list_changed
      {
        card: card_name,
        list_after: data["listAfter"]["name"],
        list_before: data["listBefore"]["name"],
        type: "moved"
      }
    end

    def updateCard_card_closed
      {
        card: card_name,
        type: data["card"]["closed"] == true ? "archived" : "unarchived"
      }
    end

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
  end
end
