class AddTwhIdToPic < ActiveRecord::Migration[5.0]
  def change
    add_column :pics, :twh_id, :integer
  end
end
