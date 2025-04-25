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
    end

    it "returns 404 when favorite does not exist" do
      get favorite_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
