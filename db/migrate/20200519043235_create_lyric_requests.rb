class CreateLyricRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :lyric_requests do |t|
      t.text :lyric_detail
      t.integer :status
      t.references :song, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
