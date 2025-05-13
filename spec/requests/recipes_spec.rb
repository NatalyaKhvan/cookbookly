require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com") }
  let!(:category) { Category.create!(name: "Desserts") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake",
  instructions: "Mix and bake.",
  user: user) }

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

  describe "POST /recipes" do
    context "with valid attributes" do
      it "creates a new recipe and redirects" do
        expect {
          post recipes_path, params: {
            recipe: {
              title: "Pasta",
              instructions: "Boil noodles and mix with sauce."
            }
          }
        }.to change(Recipe, :count).by(1)

        expect(response).to redirect_to(recipe_path(Recipe.last))
      end
    end

    context "with invalid attributes" do
      it "does not create a new recipe" do
        expect {
          post recipes_path, params: {
            recipe: {
              title: "",
              instructions: ""
            }
          }
        }.not_to change(Recipe, :count)

        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      end
    end
  end

  describe "PUT /recipes/:id" do
    it "updates the recipe and redirects" do
      recipe = Recipe.create(
        title: "Soup",
        instructions: "Boil vegetables.",
        user: user
      )

      put recipe_path(recipe), params: {
        recipe: {
          title: "Updated Soup"
        }
      }

      expect(response).to redirect_to(recipe_path(recipe))
      recipe.reload
      expect(recipe.title).to eq("Updated Soup")
    end
  end

  describe "DELETE /recipes/:id" do
    it "deletes the recipe" do
      recipe = Recipe.create(
        title: "Delete Me",
        instructions: "To be deleted.",
        user: user
      )

      expect {
        delete recipe_path(recipe)
      }.to change(Recipe, :count).by(-1)

      expect(response).to redirect_to(recipes_path)
    end
  end
end
