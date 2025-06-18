require 'rails_helper'

RSpec.describe "IngredientRecipes", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:category) { Category.create(name: "Desserts") }
  let!(:ingredient) { Ingredient.create!(name: "Sugar") }
  let!(:recipe) do
    Recipe.create!(
      title: "Chocolate Cake",
      instructions: "Mix and bake.",
      user: user
    )
  end
  let!(:ingredient_recipe) do
    IngredientRecipe.create!(
      ingredient: ingredient,
      recipe: recipe,
      quantity: "2",
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

  describe "POST /ingredient_recipes" do
    context "with valid attributes" do
      it "creates a new ingredient_recipe and redirects" do
        expect {
          post ingredient_recipes_path, params: {
            ingredient_recipe: {
              ingredient_id: ingredient.id,
              recipe_id: recipe.id,
              quantity: "3",
              unit: "cups"
            }
          }
        }.to change(IngredientRecipe, :count).by(1)
        expect(response).to redirect_to(ingredient_recipe_path(IngredientRecipe.last))
      end
    end

    context "with invalid attributes" do
      it "does not create and returns unprocessable_entity" do
        expect {
          post ingredient_recipes_path, params: {
            ingredient_recipe: {
              ingredient_id: nil,
              recipe_id: recipe.id,
              quantity: "",
              unit: ""
            }
          }
        }.not_to change(IngredientRecipe, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /ingredient_recipes/:id" do
    context "with valid attributes" do
      it "updates the ingredient_recipe and redirects" do
        patch ingredient_recipe_path(ingredient_recipe), params: {
          ingredient_recipe: {
            quantity: "5",
            unit: "grams"
          }
        }
        expect(response).to redirect_to(ingredient_recipe_path(ingredient_recipe))
        ingredient_recipe.reload
        expect(ingredient_recipe.quantity).to eq(5.to_d)
        expect(ingredient_recipe.unit).to eq("grams")
      end
    end

    context "with invalid attributes" do
      it "does not update and returns unprocessable_entity" do
        patch ingredient_recipe_path(ingredient_recipe), params: {
          ingredient_recipe: {
            quantity: "",
            unit: ""
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        ingredient_recipe.reload
        expect(ingredient_recipe.quantity).to eq(2.to_d)
      end
    end
  end

  describe "DELETE /ingredient_recipes/:id" do
    it "deletes the ingredient_recipe and redirects to index" do
      expect {
        delete ingredient_recipe_path(ingredient_recipe)
      }.to change(IngredientRecipe, :count).by(-1)
      expect(response).to redirect_to(ingredient_recipes_path)
    end
  end
end
