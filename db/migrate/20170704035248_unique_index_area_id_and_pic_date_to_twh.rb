class UniqueIndexAreaIdAndPicDateToTwh < ActiveRecord::Migration[5.0]
  def change
    add_index(:twhs, [:area_id, :pic_date], unique: true)
  end
end
