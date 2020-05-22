class AddDefaultStatusToLyricRequests < ActiveRecord::Migration[6.0]
  def change
    change_column :lyric_requests, :status, :integer, default: 0
  end
end
