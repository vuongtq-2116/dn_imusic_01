require "spec_helper"
require "rails_helper"

RSpec.describe Album, type: :model do
  let!(:album1) { FactoryBot.create(:album, name: "ABC") }
  let!(:album2) { FactoryBot.create(:album, name: "DEF") }
  let!(:album3) { FactoryBot.create(:album, name: "GHJ") }
  describe "#associations" do
    it "when a album has many songs" do
      should have_many(:songs)
    end

    it "when a album has many album_songs" do
      should have_many(:album_songs)
    end
  end

  describe "#scopes" do
    context "when name sort ascending" do
      it "should be valid" do
        expect(Album.sort_by_name.to_sql).to eq Album.all.order(name: :asc).to_sql
      end
    end

    context "when name sort descending" do
      it "should be not valid" do
        expect(Album.sort_by_name).to_not eq [:album1, :album2, :album3]
      end
    end
  end

  describe "#nested_attributes" do
    it { should accept_nested_attributes_for(:album_songs) }
  end

  describe "#validation" do
    context "when validate name" do
      context "presence name" do
        it { should validate_presence_of(:name) }
      end

      context "max length name" do
        it { should validate_length_of(:name).is_at_most(Settings.albums.name_length_max) }
      end
    end
  end

  describe "#callback" do
    it "upcase name before save" do
      expect(album1).to receive(:upcase_name)
      album1.save
    end
  end
end
