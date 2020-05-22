require "spec_helper"
require "rails_helper"

RSpec.describe Category, type: :model do

  describe "#associations" do
    context "when a category has many songs" do
      it "should be valid" do
        should have_many(:songs)
      end
    end
  end

  describe "#scopes" do
    let!(:cate1) { FactoryBot.create :category }
    let!(:cate2) { FactoryBot.create :category }
    let!(:cate3) { FactoryBot.create :category }
    context "when name sort ascending" do
      it "should be valid" do
        expect(Category.sort_by_name.to_sql).to eq Category.all.order(name: :asc).to_sql
      end
    end

    context "when name sort descending" do
      it "should be not valid" do
        expect(Category.sort_by_name).to_not eq [:cate1, :cate2, :cate3]
      end
    end
  end

  describe "#validations" do
    let!(:cate1) { FactoryBot.create :category }
    context "when validates name" do
      context "when validates presence" do
        it "should be valid" do
          should validate_presence_of(:name)
        end
      end

      context "when validates length" do
        context "when name length" do
          it "should be valid" do
            should validate_length_of(:name).is_at_least(Settings.categories.name_length_min)
                                            .is_at_most(Settings.categories.name_length_max)
          end
        end
      end

      context "when validates uniqueness" do
        context "when name uniq" do
          subject { cate1 }
          it { should validate_uniqueness_of(:name) }
        end
      end
    end
  end
end
