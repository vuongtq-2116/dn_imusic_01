class AddDeletionToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :deleted_at, :datetime, default: nil
  end
end
