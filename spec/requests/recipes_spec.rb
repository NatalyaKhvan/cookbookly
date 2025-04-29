require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake", instructions: "Mix and bake.", user: user) }

  describe "GET /recipes" do
    it "returns a successful response" do
      get recipes_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Chocolate Cake")
    end
  end

  describe "GET /recipes/:id" do
    it "shows the recipe" do
      get recipe_path(recipe)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Chocolate Cake")
    end

    it "returns 404 when no recipe exists" do
      get recipe_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
