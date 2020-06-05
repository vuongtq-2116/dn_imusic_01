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
        context "with name invalid" do
          it "render new" do
            post :create, params: {album: FactoryBot.attributes_for(:album, name: nil, album_songs_attributes: {"0" => {song_id: @song.id}})}
            expect(response).to render_template :new
          end

          it "does not save the new album" do
            expect{
              post :create, params: {album: FactoryBot.attributes_for(:album, name: nil, album_songs_attributes: {"0" => {song_id: @song.id}})}
            }.to_not change(Album,:count)
          end

          it "show flash create fail" do
            post :create, params: {album: FactoryBot.attributes_for(:album, name: nil, album_songs_attributes: {"0" => {song_id: @song.id}})}
            expect(flash[:danger]).to eq(I18n.t "admin.albums.create.fail")
          end
        end

        context "with album_song_attributes invalid" do
          context "when duplicate song" do
            before do
              post :create, params: {album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id}, "1" => {song_id: @song.id}})}
            end

            it "render new" do
              expect(response).to render_template :new
            end

            it "show flash create fail duplicate song" do
              expect(flash[:danger]).to eq(I18n.t "admin.albums.create.dup")
            end
          end

          context "when delete all song" do
            before do
              post :create, params: {album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id, _destroy: 1}})}
            end
            it "render new" do
              expect(response).to render_template :new
            end

            it "show flash create fail cannot delete all song" do
              expect(flash[:danger]).to eq(I18n.t "admin.albums.update.fail_cannot_remove")
            end
          end
        end
      end
    end
  end

  describe "PUT update" do
    context "when access to update" do
      before do
        @song = FactoryBot.create(:song, user: @admin, category: FactoryBot.create(:category))
        @album = FactoryBot.create(:album)
        sign_in @admin
      end

      context "with valid attributes" do
        before :each do
          put :update, params: {id: @album, album: FactoryBot.attributes_for(:album, name: "AAA", album_songs_attributes: {"0" => {song_id: @song.id}})}
        end

        it "return a 302 response" do
          expect(response).to have_http_status "302"
        end

        it "redirects to the index album" do
          expect(response).to redirect_to admin_albums_path
        end

        it "changes @album's attributes" do
          @album.reload
          @album.name.should eq("AAA")
        end

        it "assign @album" do
          @album.reload
          expect(assigns(:album)).to eq(@album)
        end

        it "show flash update success" do
          expect(flash[:success]).to eq(I18n.t "admin.albums.update.success")
        end
      end

      context "with invalid attributes" do
        context "with name invalid" do
          before :each do
            put :update, params: {id: @album, album: FactoryBot.attributes_for(:album, name: nil, album_songs_attributes: {"0" => {song_id: @song.id}})}
          end
          it "return a 200 response" do
            expect(response).to have_http_status "200"
          end

          it "re-render edit album" do
            expect(response).to render_template :edit
          end

          it "does not change @album's attributes" do
            @album.reload
            @album.name.should eq(@album.name)
          end

          it "assign @album" do
            @album.reload
            expect(assigns(:album)).to eq(@album)
          end

          it "show flash update fail" do
            expect(flash[:danger]).to eq(I18n.t "admin.albums.update.fail")
          end
        end

        context "with album_song_attributes invalid" do
          context "when duplicate song" do
            before do
              put :update, params: {id: @album, album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id}, "1" => {song_id: @song.id}})}
            end

            it "render new" do
              expect(response).to redirect_to edit_admin_album_path @album
            end

            it "show flash create fail duplicate song" do
              expect(flash[:danger]).to eq(I18n.t "admin.albums.create.dup")
            end
          end

          context "when delete all song" do
            before do
              put :update, params: {id: @album, album: FactoryBot.attributes_for(:album, album_songs_attributes: {"0" => {song_id: @song.id, _destroy: 1}})}
            end
            it "render new" do
              expect(response).to redirect_to edit_admin_album_path @album
            end

            it "show flash create fail cannot delete all song" do
              expect(flash[:danger]).to eq(I18n.t "admin.albums.update.fail_cannot_remove")
            end
          end
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "when access to detele" do
      before :each do
        sign_in @admin
        @album = FactoryBot.create(:album)
      end
      context "when destroy successfully" do
        it "deletes the album" do
          expect{
            delete :destroy, params: {id: @album}
          }.to change(Album,:count).by(-1)
        end

        it "redirects to index" do
          delete :destroy, params: {id: @album}
          expect(response).to redirect_to admin_albums_path
        end

        it "show flash delete success" do
          delete :destroy, params: {id: @album}
          expect(flash[:success]).to eq(I18n.t "admin.albums.destroy.success")
        end
      end

      context "when destroy fail" do
        it "deletes the album" do
          expect{
            delete :destroy, params: {id: FactoryBot.create(:album)}
          }.to change(Album,:count).by(0)
        end

        it "redirects to index" do
          delete :destroy, params: {id: FactoryBot.create(:album)}
          expect(response).to redirect_to admin_albums_path
        end
      end
    end
  end

  describe "params album_song from client" do
    before :each do
      sign_in @admin
    end

    it "not duplicate song in a album" do
      params = {album: {name: "AAA", album_songs_attributes: {}}}
      expect(controller.send(:check_params_duplicate, params)).to eq(0)
    end

    it "duplicate song in a album" do
      params = {album: {name: "AAA", album_songs_attributes: {"0"=> {song_id: 1}, "1" => {song_id: 1}}}}
      expect(controller.send(:check_params_duplicate, params)).to eq(1)
    end

    it "not delete all song in a album" do
      params = {album: {name: "AAA", album_songs_attributes: {"0"=> {song_id: 1, _destroy: 1}, "1" => {song_id: 2, _destroy: 1}}}}
      expect(controller.send(:check_params_duplicate, params)).to eq(2)
    end
  end
end
