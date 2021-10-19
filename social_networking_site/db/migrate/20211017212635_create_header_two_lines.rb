# MHK
# Sets up the website H2 line association with Member
class CreateHeaderTwoLines < ActiveRecord::Migration[6.1]
  def change
    create_table :header_two_lines do |t|
      t.belongs_to :member, foreign_key: true
      t.string :header_two
      t.timestamps
    end
  end
end
