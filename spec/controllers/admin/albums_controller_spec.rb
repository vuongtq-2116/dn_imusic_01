require "spec_helper"
require "rails_helper"

RSpec.describe Admin::AlbumsController, type: :controller do
  before do
    @admin = FactoryBot.create(:user)
    @user = FactoryBot.create(:user, role: 0)
  end

  describe "GET index/edit/new" do
    context "when access to index" do
      let!(:albums) do
        FactoryBot.create_list :album, 5
        Album.all
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

        it "assigns @albums" do
          get :index
          expect(assigns :albums).to eq(albums.sort_by_name.to_a)
        end

        it { should route(:get, "admin/albums").to(action: :index) }
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
      let!(:album) { FactoryBot.create :album }
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

      it "assigns @album" do
        get :new
        expect(assigns(:album)).to be_a_new(Album)
      end
      it { should route(:get, "admin/albums/new").to(action: :new) }
    end

    context "when access to edit" do
      let!(:album) { FactoryBot.create :album }
      before do
        sign_in @admin
      end

      it "return a 200 response" do
        get :edit, params: { id: album }
        expect(response).to have_http_status "200"
      end

      it "render view edit" do
        get :edit, params: { id: album }
        expect(response).to render_template :edit
      end

      it "assigns @album" do
        get :edit, params: { id: album }
        expect(assigns(:album)).to eq(album)
      end

      it { should route(:get, "admin/albums/1/edit").to(action: :edit, id: 1) }
    end

    context "when access to show" do
      let!(:album) { FactoryBot.create :album }
      before do
        sign_in @admin
      end

      it "return a 200 response" do
        get :show, params: { id: album }
        expect(response).to have_http_status "200"
      end

      it "render view show" do
        get :show, params: { id: album }
        expect(response).to render_template :show
      end

      it "assigns @album" do
        get :show, params: { id: album }
        expect(assigns(:album)).to eq(album)
      end

      it { should route(:get, "admin/albums/1").to(action: :show, id: 1) }
    end
  end

  describe "POST create" do
    before do
      @song = FactoryBot.create(:song, user: @admin, category: FactoryBot.create(:category))
      sign_in @admin
    end
    context "when access to create" do
      context "with valid attributes" do
        it "redirects to the index album" do
          post :create, params: {album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id}})}
          expect(response).to redirect_to admin_albums_path
        end

        it "creates a new album" do
          expect{
            post :create, params: {album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id}})}
          }.to change(Album,:count).by(1)
        end

        it "show flash create success" do
          post :create, params: {album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id}})}
          expect(flash[:success]).to eq(I18n.t "admin.albums.create.success")
        end
      end

      context "with invalid attributes" do
        it "render new" do
          post :create, params: {album: FactoryBot.attributes_for(:album, name: nil)}
          expect(response).to render_template :new
        end

        it "does not save the new album" do
          expect{
            post :create, params: {album: FactoryBot.attributes_for(:album, name: nil)}
          }.to_not change(Album,:count)
        end

        it "show flash create fail" do
          post :create, params: {album: FactoryBot.attributes_for(:album, name: nil)}
          expect(flash[:danger]).to eq(I18n.t "admin.albums.create.fail")
        end
      end
    end
  end
end
