class RenamePregectureCodeColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :pregecture_code, :prefecture_code
  end
end
