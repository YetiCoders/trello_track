class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :user_id, null: false
      t.json :member_ids

      t.timestamps
    end

    add_index :followers, :user_id
  end
end
