require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let!(:user) { User.create!(username: "chef", email: "chef@example.com", password: "password") }
  let!(:category) { Category.create!(name: "Desserts") }

  let!(:recipe) do
    Recipe.create!(
      title: "Chocolate Cake",
      instructions: "Mix and bake.",
      user: user,
      categories: [ category ]
    )
  end

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /recipes" do
    it "shows the list of recipes" do
      get recipes_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Chocolate Cake")
    end
  end

  describe "GET /recipes/:id" do
    it "shows a single recipe with reviews" do
      get recipe_path(recipe)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Chocolate Cake")
    end
  end

  describe "GET /recipes/new" do
    it "renders the new recipe form" do
      get new_recipe_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /recipes" do
    it "creates a new recipe" do
      expect {
        post recipes_path, params: {
          recipe: {
            title: "Tiramisu",
            instructions: "Layer and chill.",
            category_ids: [ category.id ]
          }
        }
      }.to change(Recipe, :count).by(1)

      expect(response).to redirect_to(recipe_path(Recipe.last))
      follow_redirect!
      expect(response.body).to include("Tiramisu")
    end
  end

  describe "GET /recipes/:id/edit" do
    it "renders the edit form for the owner" do
      get edit_recipe_path(recipe)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /recipes/:id" do
    it "updates the recipe" do
      patch recipe_path(recipe), params: {
        recipe: { title: "Updated Cake" }
      }
      expect(response).to redirect_to(recipe_path(recipe))
      follow_redirect!
      expect(response.body).to include("Updated Cake")
    end
  end

  describe "DELETE /recipes/:id" do
    it "deletes the recipe" do
      expect {
        delete recipe_path(recipe)
      }.to change(Recipe, :count).by(-1)

      expect(response).to redirect_to(recipes_path)
    end
  end

  describe "unauthorized user access" do
    let!(:other_user) { User.create!(username: "intruder", email: "badguy@example.com", password: "password") }

    before do
      delete logout_path
      post login_path, params: { email: other_user.email, password: "password" }
    end

    it "prevents editing someone else's recipe" do
      get edit_recipe_path(recipe)
      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include("You do not have permission")
    end

    it "prevents updating someone else's recipe" do
      patch recipe_path(recipe), params: {
        recipe: { title: "Hacked Cake" }
      }
      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include("You do not have permission")
    end

    it "prevents deleting someone else's recipe" do
      expect {
        delete recipe_path(recipe)
      }.not_to change(Recipe, :count)

      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include("You do not have permission")
    end
  end
end
