class CreateTwhs < ActiveRecord::Migration[5.0]
  def change
    create_table :twhs do |t|
      t.integer :area_id
      t.date :pic_date
      t.integer :wh

      t.timestamps
    end
  end
end
