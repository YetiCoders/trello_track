class AlterUsersAddSettings < ActiveRecord::Migration
  def change
    add_column :users, :settings, :json

    User.all.each do |u|
      u.update_column(:settings, { report_type: :single }.to_json) if u.subscribed?
    end
  end
end
