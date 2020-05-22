require "spec_helper"
require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  describe "GET index" do
    before do
      @admin = FactoryBot.create(:user)
      @user = FactoryBot.create(:user, role: 0)
    end

    context "when access to index" do
      let!(:categories) do
        FactoryBot.create_list :category, 5
        Category.all
      end

      context "when logged with admin" do
        it "return a 200 response" do
          sign_in @admin
          get :index
          expect(response).to have_http_status "200"
        end

        it "render view index" do
          sign_in @admin
          get :index
          expect(response).to render_template :index
        end

        it "assigns @categories" do
          sign_in @admin
          get :index
          expect(assigns :categories).to eq(categories.sort_by_name.to_a)
        end
      end

      context "when logged with user" do
        it "return a 302 response" do
          sign_in @user
          get :index
          expect(response).to have_http_status "302"
        end
      end

      context "no login" do
        it "redirects to the sign-in page" do
          get :index
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context "when access to new" do
      let!(:category) { FactoryBot.create :category }

      context "when logged with admin" do
        it "return a 200 response" do
          sign_in @admin
          get :new
          expect(response).to have_http_status "200"
        end

        it "render view new" do
          sign_in @admin
          get :new
          expect(response).to render_template :new
        end

        it "assigns @category" do
          sign_in @admin
          get :new
          expect(assigns(:category)).to be_a_new(Category)
        end
      end
    end
  end
end
