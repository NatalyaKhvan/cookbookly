require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com") }
  let!(:recipe) { Recipe.create!(title: "Test Recipe", instructions: "Do this.", user: user) }
  let!(:favorite) { Favorite.create!(user: user, recipe: recipe) }

  describe "GET /favorites" do
    it "returns a successful response and lists favorites" do
      get favorites_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /favorites/:id" do
    it "shows a favorite" do
      get favorite_path(favorite)
      expect(response).to have_http_status(200)
      expect(response.body).to include(favorite.recipe.title)
      expect(response.body).to include(favorite.user.username)
    end

    it "returns 404 when favorite does not exist" do
      get favorite_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /favorites/new" do
    it "returns a successful response for the new favorite form" do
      get new_favorite_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /favorites" do
    it "creates a new favorite" do
      expect {
        post favorites_path, params: { favorite: { user_id: user.id, recipe_id: recipe.id } }
      }.to change(Favorite, :count).by(1)
      expect(response).to redirect_to(favorite_path(Favorite.last))
    end
  end

  describe "GET /favorites/:id/edit" do
    it "returns a successful response for the edit favorite form" do
      get edit_favorite_path(favorite)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /favorites/:id" do
    it "updates an existing favorite" do
      patch favorite_path(favorite), params: { favorite: { user_id: user.id, recipe_id: recipe.id } }
      favorite.reload
      expect(favorite.user_id).to eq(user.id)
      expect(response).to redirect_to(favorite_path(favorite))
    end
  end

  describe "DELETE /favorites/:id" do
    it "deletes an existing favorite" do
      expect {
        delete favorite_path(favorite)
      }.to change(Favorite, :count).by(-1)
      expect(response).to redirect_to(favorites_path)
    end
  end
end
