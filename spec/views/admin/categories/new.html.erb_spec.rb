require "spec_helper"
require "rails_helper"
RSpec.describe "admin/categories/new", type: :view do
  before do
    @admin = FactoryBot.create(:user)
    sign_in @admin
    assign(:category, FactoryBot.create(:category))
    render
  end

  context "when logged in" do
    it "displays title new category" do
      expect(rendered).to have_content I18n.t("admin.categories.new.content")
    end

    it "renders _form partial" do
      view.should render_template(:partial => "_form")
    end

    it "shows input box" do
      expect(rendered).to have_selector("input#category_name")
    end

    it "shows button create" do
      expect(rendered).to have_selector("input[type = \"submit\"]")
    end
  end
end
