require 'spec_helper'

describe HomeHelper do
  describe "action_describe" do
    it "all actions" do
      assign(:members, { "aaa" => TrelloSpecHelper.member(create(:user, uid: "aaa", name: "User 1")) })

      all_actions = {
        addAttachmentToCard: {
          data: { "card" => { "name" => "Card 1" }, "attachment" => { "name" => "card_1.jpg", "url" => "yeticoders.com" }},
          expected: "Attached <span class=\"attachment\"><a href=\"yeticoders.com\" target=\"_blank\">card_1.jpg</a></span> to <span class=\"card\">Card 1</span>"
        },
        addChecklistToCard: {
          data: { "card" => { "name" => "Card 1" }, "checklist" => { "name" => "Checklist 1" } },
          expected: "Added <span class=\"checklist\">Checklist 1</span> to <span class=\"card\">Card 1</span>"
        },
        addMemberToBoard: {
          data: { "idMemberAdded" => "aaa" },
          expected: "Added <span class=\"user\">User 1</span> to this board"
        },
        addMemberToCard: {
          data: { "card" => { "name" => "Card 1" } },
          member_participant: { "fullName" => "User 2" },
          expected: "Added <span class=\"user\">User 2</span> to <span class=\"card\">Card 1</span>"
        },
        addMemberToOrganization: {
          data: { "idMemberAdded" => "aaa", "organization" => { "name" => "Organization 1" } },
          expected: "Added <span class=\"user\">User 1</span> to organization <span class=\"organization\">Organization 1</span>"
        },
        addToOrganizationBoard: {
          data: { "board" => { "name" => "Board 1" }, "organization" => { "name" => "Organization 1" } },
          expected: "Added board <span class=\"board\">Board 1</span> to <span class=\"organization\">Organization 1</span>"
        },
        commentCard: {
          data: { "card" => { "name" => "Card 1" }, "text" => "comment 1" },
          expected: "Commented <span class=\"card\">Card 1</span> <span class=\"comment\">comment 1</span>"
        },
        convertToCardFromCheckItem: {
          data: { "card" => { "name" => "Card 1" }, "cardSource" => { "name" => "Card 2" } },
          expected: "Converted <span class=\"card\">Card 1</span> from a checklist item on <span class=\"card_source\">Card 2</span>"
        },
        copyBoard: {
          data: { "board" => { "name" => "Board 1" }, "boardSource" => { "name" => "Board 2" } },
          expected: "Copied board <span class=\"board\">Board 1</span> from <span class=\"board_source\">Board 2</span>"
        },
        createBoard: {
          data: { "board" => { "name" => "Board 1" } },
          expected: "Created board <span class=\"board\">Board 1</span>"
        },
        createCard: {
          data: { "card" => { "name" => "Card 1" }, "list" => { "name" => "List 1" } },
          expected: "Added card <span class=\"card\">Card 1</span> to <span class=\"list\">List 1</span>"
        },
        copyCard: {
          data: { "card" => { "name" => "Card 1" }, "cardSource" => { "name" => "Card 2" }, "list" => { "name" => "List 1" } },
          expected: "Copied <span class=\"card\">Card 1</span> from <span class=\"card_source\">Card 2</span> in list <span class=\"list\">List 1</span>"
        },
        createList: {
          data: { "list" => { "name" => "List 1" } },
          expected: "Added list <span class=\"list\">List 1</span>"
        },
        createOrganization: {
          data: { "organization" => { "name" => "Organization 1" } },
          expected: "Created organization <span class=\"organization\">Organization 1</span>"
        },
        deleteAttachmentFromCard: {
          data: { "card" => { "name" => "Card 1" }, "attachment" => { "name" => "card_1.jpg" }},
          expected: "Deleted <span class=\"attachment\">card_1.jpg</span> from <span class=\"card\">Card 1</span>"
        },
        deleteCard: {
          data: { "card" => { "idShort" => "111" }, "list" => { "name" => "List 1" } },
          expected: "Deleted card <span class=\"id_short\">#111</span> from <span class=\"list\">List 1</span>"
        },
        disablePowerUp: {
          data: { "value" => "calendar" },
          expected: "Disabled <span class=\"power_up\">calendar</span> power-up on this board"
        },
        enablePowerUp: {
          data: { "value" => "calendar" },
          expected: "Enabled <span class=\"power_up\">calendar</span> power-up on this board"
        },
        makeAdminOfBoard: {
          data: { "board" => { "name" => "Board 1" } },
          member_participant: { "fullName" => "User 2" },
          expected: "Made <span class=\"user\">User 2</span> an admin of board <span class=\"board\">Board 1</span>"
        },
        makeNormalMemberOfBoard: {
          data: { "board" => { "name" => "Board 1" } },
          member_participant: { "fullName" => "User 2" },
          expected: "Made <span class=\"user\">User 2</span> a normal user on board <span class=\"board\">Board 1</span>"
        },
        makeNormalMemberOfOrganization: {
          data: { "organization" => { "name" => "Organization 1" } },
          member_participant: { "fullName" => "User 2" },
          expected: "Made <span class=\"user\">User 2</span> a normal user in organization <span class=\"organization\">Organization 1</span>"
        },
        moveCardFromBoard: {
          data: { "card" => { "name" => "Card 1" }, "boardTarget" => { "name" => "Board 1" } },
          expected: "Transferred card <span class=\"card\">Card 1</span> to <span class=\"board_target\">Board 1</span>"
        },
        moveListFromBoard: {
          data: { "list" => { "name" => "List 1" }, "boardTarget" => { "name" => "Board 1" } },
          expected: "Transferred list <span class=\"list\">List 1</span> to <span class=\"board_target\">Board 1</span>"
        },
        moveCardToBoard: {
          data: { "card" => { "name" => "Card 1" }, "boardSource" => { "name" => "Board 2" } },
          expected: "Transferred card <span class=\"card\">Card 1</span> from <span class=\"board_source\">Board 2</span>"
        },
        moveListToBoard: {
          data: { "list" => { "name" => "List 1" }, "boardSource" => { "name" => "Board 2" } },
          expected: "Transferred list <span class=\"list\">List 1</span> from <span class=\"board_source\">Board 2</span>"
        },
        removeChecklistFromCard: {
          data: { "card" => { "name" => "Card 1" }, "checklist" => { "name" => "Checklist 1" } },
          expected: "Removed <span class=\"checklist\">Checklist 1</span> from <span class=\"card\">Card 1</span>"
        },
        removeMemberFromCard: {
          data: { "card" => { "name" => "Card 1" } },
          member_participant: { "fullName" => "User 2" },
          expected: "Removed <span class=\"user\">User 2</span> from <span class=\"card\">Card 1</span>"
        },
        updateBoard: [
          {
            data: { "old" => { "name" => "Board 1" } },
            expected: "Renamed this board (from <span class=\"board_old\">Board 1</span>)"
          },
          {
            data: {"board" => { "name" => "Board 1" }},
            expected: "Updated board <span class=\"board\">Board 1</span>"
          }
        ],
        updateCard: [
          {
            data: { "card" => { "name" => "Card 1" }, "listAfter" => { "name" => "List 2"}, "listBefore" => { "name" => "List 1"} },
            expected: "Moved card <span class=\"card\">Card 1</span> from <span class=\"list_before\">List 1</span> to <span class=\"list_after\">List 2</span>"
          },
          {
            data: { "card" => { "name" => "Card 1", "closed" => true } },
            expected: "Archived card <span class=\"card\">Card 1</span>"
          },
          {
            data: { "card" => { "name" => "Card 1", "closed" => false } },
            expected: "Unarchived card <span class=\"card\">Card 1</span>"
          },
          {
            data: { "card" => { "name" => "Card 1", "pos" => 2 }, "old" => { "pos" => 1 } },
            expected: "Moved down card <span class=\"card\">Card 1</span>"
          },
          {
            data: { "card" => { "name" => "Card 1", "pos" => 2 }, "old" => { "pos" => 3 } },
            expected: "Moved up card <span class=\"card\">Card 1</span>"
          },
          {
            data: { "card" => { "name" => "Card 1" } },
            expected: "Updated card <span class=\"card\">Card 1</span>"
          }
        ],
        updateCheckItemStateOnCard: [
          {
            data: { "card" => { "name" => "Card 1" }, "checkItem" => { "name" => "Check Item 1", "state" => "complete"} },
            expected: "Completed <span class=\"check_item\">Check Item 1</span> on <span class=\"card\">Card 1</span>"
          },
          {
            data: { "card" => { "name" => "Card 1" }, "checkItem" => { "name" => "Check Item 1", "state" => "incomplete"} },
            expected: "Marked <span class=\"check_item\">Check Item 1</span> incomplete on <span class=\"card\">Card 1</span>"
          },
        ],
        updateChecklist: {
          data: { "checklist" => { "name" => "CheckList 1" }, "old" => { "name" => "CheckList 2" } },
          expected: "Renamed <span class=\"checklist\">CheckList 1</span> (from <span class=\"checklist_old\">CheckList 2</span>)"
        },
        updateList: [
          {
            data: { "list" => { "name" => "List 1", "closed" => true } },
            expected: "Archived list <span class=\"list\">List 1</span>"
          },
          {
            data: { "list" => { "name" => "List 1", "closed" => false } },
            expected: "Unarchived list <span class=\"list\">List 1</span>"
          },
          {
            data: { "list" => { "name" => "List 1" } },
            expected: "Updated list <span class=\"list\">List 1</span>"
          }
        ],
        updateMember: {
          expected: :updateMember
        },
        updateOrganization: [
          {
            data: { "organization" => { "name" => "Organization 1" }, "old" => { "name" => "Organization 2" } },
            expected: "Changed name of organization <span class=\"organization\">Organization 1</span>"
          },
          {
            data: { "organization" => { "name" => "Organization 1", "displayName" => "Org 1" }, "old" => { "displayName" => "Org 2" } },
            expected: "Changed display name of organization <span class=\"organization\">Organization 1</span>"
          },
          {
            data: { "organization" => { "name" => "Organization 1", "website" => "yeticoders.com" } },
            expected: "Set website of organization <span class=\"organization\">Organization 1</span>"
          },
          {
            data: { "organization" => { "name" => "Organization 1" } },
            expected: "Updated organization <span class=\"organization\">Organization 1</span>"
          },
        ]
      }
      all_actions.each do |type, tests|
        [tests].flatten.each do |test|
          expected = test.delete(:expected)
          test[:type] = type
          expect(helper.action_describe(test)).to eq(expected)
        end
      end
    end

    it "without describe action in development env" do
      Rails.env = "development"
      expect(
        helper.action_describe({ type: :updateMember, data: {"card" => { "name" => "Card 1" }}})
      ).to eq("{:type=>:updateMember, :data=>{\"card\"=>{\"name\"=>\"Card 1\"}}}")
      Rails.env = "test"
    end
  end
end
