require "spec_helper"
require "rails_helper"
RSpec.describe "admin/categories/index", type: :view do
  before do
    @admin = FactoryBot.create(:user)
    sign_in @admin
    @categories = FactoryBot.create_list :category, 5
    @cate1 = FactoryBot.create(:category)
    @categories << @cate1
    allow(view).to receive_messages(:will_paginate => nil)
  end

  context "when logged in" do
    it "displays title category" do
      render
      expect(rendered).to have_content I18n.t("layouts.header.category")
    end

    it "shows name @cate1" do
      render
      expect(rendered).to have_content(@cate1.name)
    end

    it "shows tag button new" do
      render
      expect(rendered).to have_selector("a[href = '/en/admin/categories/new']")
    end

    it "renders _category partial" do
      render
      view.should render_template(:partial => "_category", count: 6)
    end

    it "shows no category to display" do
      assign(:categories, FactoryBot.create_list(:category, 0))
      render
      expect(rendered).to have_content(I18n.t("admin.categories.no_cat"))
    end
  end
end
