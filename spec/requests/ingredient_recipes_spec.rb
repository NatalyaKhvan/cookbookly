require 'rails_helper'

RSpec.describe "IngredientRecipes", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake", instructions: "Mix and bake.", user: user) }
  let!(:ingredient) { Ingredient.create!(name: "Sugar") }
  let!(:ingredient_recipe) do
    IngredientRecipe.create!(
      recipe: recipe,
      ingredient: ingredient,
      quantity: 2,
      unit: "cups"
    )
  end

  describe "GET /ingredient_recipes" do
    it "returns a successful response and lists ingredient usages" do
      get ingredient_recipes_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("2.0 cups of")
      expect(response.body).to include("Sugar")
      expect(response.body).to include("Chocolate Cake")
    end
  end

  describe "GET /ingredient_recipes/:id" do
    it "shows a single ingredient_recipe" do
      get ingredient_recipe_path(ingredient_recipe)
      expect(response).to have_http_status(200)
      expect(response.body).to include("2.0 cups of")
      expect(response.body).to include("Sugar")
      expect(response.body).to include("Chocolate Cake")
    end

    it "returns 404 when no ingredient_recipe exists" do
        get ingredient_recipe_path(id: 999999)
        expect(response).to have_http_status(:not_found)
    end
  end
end
