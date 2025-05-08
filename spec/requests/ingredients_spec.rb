require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  let!(:ingredient) { Ingredient.create!(name: "Sugar") }

  describe "GET /ingredients" do
    it "returns a successful response and includes ingredient name" do
      get ingredients_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sugar")
    end
  end

  describe "GET /ingredients/:id" do
    context "when ingredient exists" do
      it "returns the ingredient" do
        get ingredient_path(ingredient)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Sugar")
      end
    end

    context "when ingredient does not exist" do
      it "returns a not found error" do
        get ingredient_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /ingredients" do
    context "with valid attributes" do
      it "creates a new ingredient and redirects" do
        expect {
          post ingredients_path, params: { ingredient: { name: "Flour" } }
        }.to change(Ingredient, :count).by(1)
        expect(response).to redirect_to(ingredient_path(Ingredient.last))
      end
    end

    context "with invalid attributes" do
      it "does not create a new ingredient" do
        expect {
          post ingredients_path, params: { ingredient: { name: "" } }
        }.not_to change(Ingredient, :count)
        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      end
    end
  end

  describe "PATCH /ingredients/:id" do
    it "updates the ingredient and redirects" do
      patch ingredient_path(ingredient), params: { ingredient: { name: "Brown Sugar" } }
      expect(response).to redirect_to(ingredient_path(ingredient))
      ingredient.reload
      expect(ingredient.name).to eq("Brown Sugar")
    end
  end

  describe "DELETE /ingredients/:id" do
    it "deletes the ingredient and redirects" do
      extra_ingredient = Ingredient.create!(name: "Salt")
      expect {
        delete ingredient_path(extra_ingredient)
      }.to change(Ingredient, :count).by(-1)
      expect(response).to redirect_to(ingredients_path)
    end
  end
end
