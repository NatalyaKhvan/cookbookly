require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:other_user) { User.create!(username: "otheruser", email: "other@example.com", password: "password") }
  let!(:recipe) { Recipe.create!(title: "Test Recipe", instructions: "Do this.", user: other_user) }
  let!(:favorite) { Favorite.create!(user: user, recipe: recipe) }

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /favorites" do
    it "returns a successful response and lists favorites" do
      get favorites_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Test Recipe")
    end
  end

  describe "POST /recipes/:recipe_id/favorite" do
    context "when favoriting another user's recipe" do
      it "creates a new favorite and redirects to the recipe" do
        new_recipe = Recipe.create!(title: "New Recipe", instructions: "Cook well.", user: other_user)

        expect {
          post favorite_recipe_path(new_recipe)
        }.to change(Favorite, :count).by(1)

        expect(response).to redirect_to(recipe_path(new_recipe))
        follow_redirect!
        expect(response.body).to include("Recipe was added to your favorites.")
      end
    end

    context "when favoriting own recipe" do
      it "does not create a favorite and redirects with alert" do
        own_recipe = Recipe.create!(title: "Own Recipe", instructions: "Do own stuff.", user: user)

        expect {
          post favorite_recipe_path(own_recipe)
        }.not_to change(Favorite, :count)

        expect(response).to redirect_to(recipe_path(own_recipe))
        follow_redirect!
        expect(response.body).to include("You cannot favorite your own recipe.")
      end
    end

    context "when recipe is already favorited" do
      it "does not duplicate favorite" do
        expect {
          post favorite_recipe_path(recipe)
        }.not_to change(Favorite, :count)

        expect(response).to redirect_to(recipe_path(recipe))
        follow_redirect!
        expect(response.body).to include("Recipe was added to your favorites.")
      end
    end

    context "when not logged in" do
      before { delete logout_path }

      it "redirects to the login page" do
        recipe = Recipe.create!(title: "Some Recipe", instructions: "Step 1", user: other_user)
        post favorite_recipe_path(recipe)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /favorites/:id" do
    it "deletes an existing favorite and redirects to recipe page" do
      expect {
        delete favorite_path(favorite)
      }.to change(Favorite, :count).by(-1)

      expect(response).to redirect_to(recipe_path(recipe))
      follow_redirect!
      expect(response.body).to include("Removed from favorites.")
    end

    it "does not allow deleting another user's favorite" do
      other_favorite = Favorite.create!(user: other_user, recipe: recipe)

      expect {
        delete favorite_path(other_favorite)
      }.not_to change(Favorite, :count)

      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include("You do not have permission to remove this favorite.")
    end
  end
end
