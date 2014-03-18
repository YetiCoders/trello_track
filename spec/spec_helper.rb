# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
#Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.filter_run_excluding :remote => true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
end

def login(user)
  session[:user_id] = user.id
  session[:token] = user.oauth_token
end

class TrelloSpecHelper
  def self.member(user = nil)
    user ||= FactoryGirl.create(:user)
    {
      "id" => user.uid,
      "username" => user.name,
      "email" => nil,
      "full_name" => user.name,
      "initials" => user.name[0],
      "avatar_id" => "",
      "bio" => ""
    }.jsoned_into(Trello::Member)
  end

  def self.organization
    display_name = Faker::Name.title
    {
      "id" => SecureRandom.uuid,
      "name" => display_name.parameterize,
      "display_name" => display_name,
      "description" => Faker::Lorem.paragraph
    }.jsoned_into(Trello::Organization)
  end

  def self.card(members, list = nil, board = nil)
    name = Faker::Name.title
    {
      "id" => SecureRandom.uuid,
      "short_id" => Faker::Number.number(2),
      "name" => Faker::Name.title,
      "desc" => Faker::Lorem.paragraph,
      "due" => nil,
      "closed" => false,
      "url" => "https://trello.com/c/#{Faker::Lorem.word}/#{name.parameterize}",
      "short_url" => "https://trello.com/c/#{Faker::Lorem.word}",
      "idBoard" => board ? board.id : SecureRandom.uuid,
      "idMembers" => members.map(&:id),
      "idList" => list ? list.id : SecureRandom.uuid,
      "pos" => nil,
      "last_activity_date" => nil,
      "badges" => {
        "votes" => 0, "viewingMemberVoted" => false, "subscribed" => false, "fogbugz" => "", "checkItems" => 0,
        "checkItemsChecked" => 0, "comments" => 0, "attachments" => 0, "description" => false, "due" => nil
      },
      "members" => members.map{|m| m.attributes}
    }.jsoned_into(Trello::Card)
  end

  def self.action(member, action_type = "updateCard_moved")
    action =
      case action_type
        when "updateCard_moved"
          list_after_id = SecureRandom.uuid
          list_after_before = SecureRandom.uuid
          {
            "id" => SecureRandom.uuid,
            "type" => "updateCard",
            "data" => {
                "listAfter" => { "name" => Faker::Name.title, "id" => list_after_id },
                "listBefore" => { "name" => Faker::Name.title, "id" => list_after_before },
                "board" => { "name" => Faker::Name.title, "id" => SecureRandom.uuid },
                "card" => {
                  "name"=>"Nightly cron", "id" => SecureRandom.uuid,
                  "idList" => list_after_id
                },
                "old" => { "idList" => list_after_before }
            },
            "date" => "2014-03-17T14:39:27.866Z",
            "idMemberCreator" => member.id,
            "memberCreator" => member.attributes
          }
        when "addMemberToBoard"
          {
            "id" => SecureRandom.uuid,
            "idMemberCreator" => member.id,
            "data" => {
              "board" => { "name" => Faker::Name.title, "id" => SecureRandom.uuid },
              "idMemberAdded" => SecureRandom.uuid,
            },
            "type" => "addMemberToBoard",
            "date" => "2014-03-12T06:39:53.717Z",
            "memberCreator" => member.attributes
          }
      end

    action.jsoned_into(Trello::Action)
  end

  def self.list
    {
      "id" => SecureRandom.uuid,
      "name" => Faker::Name.title,
      "closed" => false,
      "idBoard" => SecureRandom.uuid
    }.jsoned_into(Trello::List)
  end

  def self.board
    {
      "id" => SecureRandom.uuid,
      "name" => Faker::Name.title,
      "desc" => Faker::Lorem.paragraph,
      "closed" => false,
      "idOrganization" => SecureRandom.uuid
    }.jsoned_into(Trello::Board)
  end
end


