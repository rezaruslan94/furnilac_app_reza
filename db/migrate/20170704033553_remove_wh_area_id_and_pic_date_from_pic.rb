class RemoveWhAreaIdAndPicDateFromPic < ActiveRecord::Migration[5.0]
  def change
    remove_column :pics, :wh
    remove_column :pics, :area_id
    remove_column :pics, :pic_date
  end
end
