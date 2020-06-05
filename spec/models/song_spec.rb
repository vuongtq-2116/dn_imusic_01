require "spec_helper"
require "rails_helper"

RSpec.describe Song, type: :model do
  let!(:song1) { FactoryBot.create(:song, name: "ABC", created_at: 2.hour.ago, artist: "UUU") }
  let!(:song2) { FactoryBot.create(:song, name: "DEF", created_at: 1.hour.ago) }
  let!(:song3) { FactoryBot.create(:song, name: "GHJ", created_at: Time.now, deleted_at: Time.now)}
  describe "#associations" do
    it "when a song belong to a user" do
      should belong_to(:user)
    end

    it "when a song belong to a category" do
      should belong_to(:category)
    end

    it "when a song has many ratings" do
      should have_many(:ratings)
    end

    it "when a song has many favorite_songs" do
      should have_many(:favorite_songs)
    end

    it "when a song has many lyric_requests" do
      should have_many(:lyric_requests)
    end

    it "when a song has many album_songs" do
      should have_many(:album_songs)
    end

    it "when a song has many comments" do
      should have_many(:comments)
    end

    it "when a song has many albums" do
      should have_many(:albums)
    end
  end

  describe "#scopes" do
    context "active" do
      context "when show song active" do
        it "should be valid" do
          expect(Song.active.to_sql).to eq Song.where(deleted_at: nil).to_sql
        end
      end

      context "when do not show song active" do
        it "should be not valid" do
          expect(Song.active).to_not eq [song3]
        end
      end
    end

    context "sort_by_created_at" do
      context "when sort desc by created at" do
        it "should be valid" do
          expect(Song.sort_by_created_at.to_sql).to eq Song.all.order(created_at: :desc).to_sql
        end
      end

      context "when sort asc by created at" do
        it "should be not valid" do
          expect(Song.sort_by_created_at).to_not eq [song1, song2, song3]
        end
      end
    end

    context "search" do
      it "search artist UUU" do
        expect(Song.search("UUU")).to eq([song1])
      end
    end
  end

  describe "#validations" do
    context "when validate name" do
      context "presence name" do
        it { should validate_presence_of(:name) }
      end
    end
  end

  describe "#methods" do
    context "when calculate blank star" do
      it { expect(song1.blank_stars).to eq(5)}
    end

    context "when favorited a song by a user" do
      before do
        @user1 = FactoryBot.create(:user)
        @user2 = FactoryBot.create(:user)
        @song = FactoryBot.create(:song)
        @fs = FactoryBot.create(:favorite_song, user_id: @user1.id, song_id: @song.id)
      end

      it { expect(@song.favorite?(@user1)).to eq(true)}

      it { expect(@song.favorite?(@user2)).to eq(false)}
    end
  end
end
