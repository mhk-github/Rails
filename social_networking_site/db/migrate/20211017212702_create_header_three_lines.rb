# MHK
# Sets up the website H3 line association with Member
class CreateHeaderThreeLines < ActiveRecord::Migration[6.1]
  def change
    create_table :header_three_lines do |t|
      t.belongs_to :member, foreign_key: true
      t.string :header_three
      t.timestamps
    end
  end
end
