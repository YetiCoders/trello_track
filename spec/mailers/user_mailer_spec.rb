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
    end
  end
end