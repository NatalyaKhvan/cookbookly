require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  let!(:ingredient) { Ingredient.create!(name: "Sugar") }

  describe "GET /ingredients" do
    it "returns a successful response" do
      get ingredients_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sugar")
    end
  end

  describe "GET /ingredients/:id" do
    it "shows the ingredient" do
      get ingredient_path(ingredient)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sugar")
    end

    it "returns 404 when no ingredient exists" do
      get ingredient_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end