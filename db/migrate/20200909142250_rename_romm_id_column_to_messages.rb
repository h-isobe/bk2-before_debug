class RenameRommIdColumnToMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :romm_id, :room_id
  end
end
