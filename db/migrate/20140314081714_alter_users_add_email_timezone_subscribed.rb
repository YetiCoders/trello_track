class AlterUsersAddEmailTimezoneSubscribed < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :time_zone, :string
    add_column :users, :subscribed, :boolean, null: false, default: false
  end
end
