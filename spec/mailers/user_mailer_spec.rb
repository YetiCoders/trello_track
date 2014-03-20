require 'spec_helper'

describe UserMailer do
  describe "no_action_email" do
    it "no_action_email" do
      mail = UserMailer.no_action_email({"card" => { "name" => "Card 1" }})
      expect(mail.subject).to eq("Trello Track: No action translation")
      expect(mail.body.encoded).to match(/\{\"card\"=>{\"name\"=>\"Card 1\"\}/)
    end
  end

  describe "follower_report" do
    it "follower_report" do
      follower = TrelloSpecHelper.member(create(:user, name: "User 1"))
      board = TrelloSpecHelper.board
      list = TrelloSpecHelper.list
      options = {
        actions: [ TrelloSpecHelper.action(follower) ],
        cards:   [ TrelloSpecHelper.card([ follower ], list, board) ],
        card_boards: { board.id => board },
        card_lists: { list.id => list },
        members: { follower.id => follower }
      }

      mail = UserMailer.follower_report("janev@example.com", follower, options)
      expect(mail.to).to eq(["janev@example.com"])
      expect(mail.subject).to eq("User 1: Trello Track Activity Report")
      expect(mail.body.encoded).to match(follower.full_name)
    end
  end

  describe "followers_report" do
    it "followers_report" do
      follower1 = TrelloSpecHelper.member(create(:user, name: "User 1"))
      follower2 = TrelloSpecHelper.member(create(:user, name: "User 2"))
      board = TrelloSpecHelper.board
      list = TrelloSpecHelper.list

      options = {
        members_info: {
          follower1.id => {
            actions: [ TrelloSpecHelper.action(follower1) ],
            cards:   [ TrelloSpecHelper.card([ follower1 ], list, board) ]
          },
          follower2.id => {
            actions: [ TrelloSpecHelper.action(follower2) ],
            cards:   [ TrelloSpecHelper.card([ follower2 ], list, board) ]
          }
        },
        card_boards: { board.id => board },
        card_lists: { list.id => list },
        members: { follower1.id => follower1, follower2.id => follower2 }
      }

      mail = UserMailer.followers_report("janev@example.com", options)
      expect(mail.to).to eq(["janev@example.com"])
      expect(mail.subject).to eq("Trello Track Activity Report")
      expect(mail.body.encoded).to match(follower1.full_name)
      expect(mail.body.encoded).to match(follower2.full_name)
    end
  end
end