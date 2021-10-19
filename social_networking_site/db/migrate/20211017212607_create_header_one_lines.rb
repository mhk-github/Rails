# MHK
# Sets up the website H1 line association with Member
class CreateHeaderOneLines < ActiveRecord::Migration[6.1]
  def change
    create_table :header_one_lines do |t|
      t.belongs_to :member, foreign_key: true
      t.string :header_one
      t.timestamps
    end
  end
end
