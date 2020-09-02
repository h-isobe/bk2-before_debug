class RenameBookIdColumnToRelationships < ActiveRecord::Migration[5.2]
  def change
    rename_column :relationships, :book_id, :followed_id
  end
end
