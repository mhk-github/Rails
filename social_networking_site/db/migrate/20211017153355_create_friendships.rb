# MHK
# Sets up the Friendship association with Member

class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.belongs_to :member, foreign_key: true
      t.integer :friend_member_id
    end
  end
end
