require 'rails_helper'

RSpec.describe "IngredientRecipes", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:other_user) { User.create!(username: "otheruser", email: "other@example.com", password: "password") }
  let!(:ingredient) { Ingredient.create!(name: "Salt") }
  let!(:recipe) { Recipe.create!(title: "Test Recipe", instructions: "Mix.", user: user) }
  let!(:ingredient_recipe) { IngredientRecipe.create!(recipe: recipe, ingredient: ingredient, quantity: "1", unit: "tsp") }

  def login(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  context "when logged in as recipe owner" do
    before { login(user) }

    describe "GET /recipes/:recipe_id/ingredient_recipes/new" do
      it "renders the new form" do
        get new_recipe_ingredient_recipe_path(recipe)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Add Ingredient to Recipe")
      end
    end

    describe "GET /recipes/:recipe_id/ingredient_recipes/:id/edit" do
      it "renders the edit form" do
        get edit_recipe_ingredient_recipe_path(recipe, ingredient_recipe)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Edit Ingredient Usage")
      end
    end

    describe "POST /recipes/:recipe_id/ingredient_recipes" do
      context "with valid attributes" do
        it "creates a new ingredient_recipe and redirects to recipe show page" do
          new_ingredient = Ingredient.create!(name: "Pepper")
          params = { ingredient_id: new_ingredient.id, quantity: "2", unit: "tsp" }

          expect {
            post recipe_ingredient_recipes_path(recipe), params: { ingredient_recipe: params }
          }.to change(IngredientRecipe, :count).by(1)

          expect(response).to redirect_to(recipe_path(recipe))
          follow_redirect!
          expect(response.body).to include("Pepper")
        end
      end

      context "with invalid attributes" do
        it "does not create and shows errors" do
          invalid = { ingredient_id: nil, quantity: "", unit: "" }

          expect {
            post recipe_ingredient_recipes_path(recipe), params: { ingredient_recipe: invalid }
          }.not_to change(IngredientRecipe, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          doc = Nokogiri::HTML(response.body)
          expect(doc.at_css('#error_explanation')).to be_present
          expect(doc.text).to include("Quantity can't be blank", "Ingredient must exist", "Unit can't be blank")
        end
      end
    end

    describe "PATCH /recipes/:recipe_id/ingredient_recipes/:id" do
      context "with valid attributes" do
        it "updates and redirects" do
          patch recipe_ingredient_recipe_path(recipe, ingredient_recipe),
                params: { ingredient_recipe: { quantity: "3.0", unit: "tbsp" } }

          expect(response).to redirect_to(recipe_path(recipe))
          ingredient_recipe.reload
          expect(ingredient_recipe.quantity.to_s).to eq("3.0")
          expect(ingredient_recipe.unit).to eq("tbsp")
        end
      end

      context "with invalid attributes" do
        it "does not update and shows errors" do
          patch recipe_ingredient_recipe_path(recipe, ingredient_recipe),
                params: { ingredient_recipe: { ingredient_id: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
          ingredient_recipe.reload
          expect(ingredient_recipe.ingredient_id).to eq(ingredient.id)
        end
      end
    end

    describe "DELETE /recipes/:recipe_id/ingredient_recipes/:id" do
      it "deletes and redirects" do
        expect {
          delete recipe_ingredient_recipe_path(recipe, ingredient_recipe)
        }.to change(IngredientRecipe, :count).by(-1)

        expect(response).to redirect_to(recipe_path(recipe))
      end
    end

    describe "GET edit on non-existent ID" do
      it "returns 404 not found for non-existent ingredient_recipe" do
        get edit_recipe_ingredient_recipe_path(recipe, "999999")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "when not logged in" do
    it "redirects to login for new" do
      get new_recipe_ingredient_recipe_path(recipe)
      expect(response).to redirect_to(login_path)
    end

    it "redirects to login for create" do
      post recipe_ingredient_recipes_path(recipe), params: {
        ingredient_recipe: { ingredient_id: ingredient.id, quantity: "1", unit: "tsp" }
      }
      expect(response).to redirect_to(login_path)
    end
  end

  context "when logged in as a different user" do
    before { login(other_user) }

    it "blocks editing someone else's recipe" do
      get edit_recipe_ingredient_recipe_path(recipe, ingredient_recipe)
      expect(response).to redirect_to(recipe_path(recipe))
      follow_redirect!
      expect(response.body).to include("not authorized")
    end

    it "blocks deleting someone else's ingredient" do
      expect {
        delete recipe_ingredient_recipe_path(recipe, ingredient_recipe)
      }.not_to change(IngredientRecipe, :count)

      expect(response).to redirect_to(recipe_path(recipe))
      follow_redirect!
      expect(response.body).to include("not authorized")
    end
  end
end
