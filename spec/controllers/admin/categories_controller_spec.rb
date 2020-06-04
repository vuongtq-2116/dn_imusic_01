require "spec_helper"
require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  before do
    @admin = FactoryBot.create(:user)
    @user = FactoryBot.create(:user, role: 0)
  end

  describe "GET index/edit/new" do
    context "when access to index" do
      let!(:categories) do
        FactoryBot.create_list :category, 5
        Category.all
      end

      context "when logged with admin" do
        before do
          sign_in @admin
        end

        it "return a 200 response" do
          get :index
          expect(response).to have_http_status "200"
        end

        it "render view index" do
          get :index
          expect(response).to render_template :index
        end

        it "assigns @categories" do
          get :index
          expect(assigns :categories).to eq(categories.sort_by_name.to_a)
        end

        it { should route(:get, "admin/categories").to(action: :index) }
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
      before do
        sign_in @admin
      end

      it "return a 200 response" do
        get :new
        expect(response).to have_http_status "200"
      end

      it "render view new" do
        get :new
        expect(response).to render_template :new
      end

      it "assigns @category" do
        get :new
        expect(assigns(:category)).to be_a_new(Category)
      end
      it { should route(:get, "admin/categories/new").to(action: :new) }
    end

    context "when access to edit" do
      let!(:category) { FactoryBot.create :category }
      before do
        sign_in @admin
      end

      it "return a 200 response" do
        get :edit, params: { id: category }
        expect(response).to have_http_status "200"
      end

      it "render view edit" do
        get :edit, params: { id: category }
        expect(response).to render_template :edit
      end

      it "assigns @category" do
        get :edit, params: { id: category }
        expect(assigns(:category)).to eq(category)
      end

      it { should route(:get, "admin/categories/1/edit").to(action: :edit, id: 1) }
    end
  end

  describe "POST create" do
    context "when access to create" do
      context "with valid attributes" do
        it "redirects to the index category" do
          sign_in @admin
          post :create, params: {category: FactoryBot.attributes_for(:category)}
          expect(response).to redirect_to admin_categories_path
        end

        it "creates a new category" do
          expect{
            post :create, params: {category: FactoryBot.create(:category)}
          }.to change(Category,:count).by(1)
        end

        it "show flash create success" do
          sign_in @admin
          post :create, params: {category: FactoryBot.attributes_for(:category)}
          expect(flash[:success]).to eq(I18n.t "admin.categories.create.success")
        end
      end

      context "with invalid attributes" do
        it "render new" do
          sign_in @admin
          post :create, params: {category: FactoryBot.attributes_for(:category, name: nil)}
          expect(response).to render_template :new
        end

        it "does not save the new category" do
          expect{
            post :create, params: {category: FactoryBot.attributes_for(:category, name: nil)}
          }.to_not change(Category,:count)
        end

        it "show flash create fail" do
          sign_in @admin
          post :create, params: {category: FactoryBot.attributes_for(:category, name: nil)}
          expect(flash[:danger]).to eq(I18n.t "admin.categories.create.fail")
        end
      end
    end
  end

  describe "PUT update" do
    context "when access to update" do
      before :each do
        @category = FactoryBot.create(:category)
      end

      context "with valid attributes" do
        before :each do
          sign_in @admin
          put :update, params: {id: @category, category: FactoryBot.attributes_for(:category, name: "Lawrance")}
        end

        it "return a 302 response" do
          expect(response).to have_http_status "302"
        end

        it "redirects to the index category" do
          expect(response).to redirect_to admin_categories_path
        end

        it "changes @category's attributes" do
          @category.reload
          @category.name.should eq("Lawrance")
        end

        it "assign @category" do
          @category.reload
          expect(assigns(:category)).to eq(@category)
        end

        it "show flash update success" do
          expect(flash[:success]).to eq(I18n.t "admin.categories.update.success")
        end
      end

      context "with invalid attributes" do
        before :each do
          sign_in @admin
          put :update, params: {id: @category, category: FactoryBot.attributes_for(:category, name: nil)}
        end
        it "return a 200 response" do
          expect(response).to have_http_status "200"
        end

        it "re-render edit category" do
          expect(response).to render_template :edit
        end

        it "does not change @category's attributes" do
          @category.reload
          @category.name.should eq(@category.name)
        end

        it "assign @category" do
          @category.reload
          expect(assigns(:category)).to eq(@category)
        end

        it "show flash update fail" do
          expect(flash[:danger]).to eq(I18n.t "admin.categories.update.fail")
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "when access to detele" do
      before :each do
        sign_in @admin
        @category = FactoryBot.create(:category)
      end
      context "when destroy successfully" do
        it "deletes the category" do
          expect{
            delete :destroy, params: {id: @category}
          }.to change(Category,:count).by(-1)
        end

        it "redirects to index" do
          delete :destroy, params: {id: @category}
          expect(response).to redirect_to admin_categories_path
        end

        it "show flash delete success" do
          delete :destroy, params: {id: @category}
          expect(flash[:success]).to eq(I18n.t "admin.categories.destroy.success")
        end
      end

      context "when destroy fail" do
        it "deletes the category" do
          expect{
            delete :destroy, params: {id: FactoryBot.create(:category)}
          }.to change(Category,:count).by(0)
        end

        it "redirects to index" do
          delete :destroy, params: {id: FactoryBot.create(:category)}
          expect(response).to redirect_to admin_categories_path
        end
      end
    end
  end
end
