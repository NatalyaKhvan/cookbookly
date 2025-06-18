require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:recipe) { Recipe.create!(title: "Test Recipe", instructions: "Cook it", user: user) }
  let!(:review) { Review.create!(content: "Great recipe", rating: 5, user: user, recipe: recipe) }
  let!(:favorite) { Favorite.create!(user: user, recipe: recipe) }

  describe "GET /dashboard" do
    context "when the user is logged in" do
      before do
        post login_path, params: { email: user.email, password: "password" }
        get dashboard_path
      end

      it "renders successfully" do
        expect(response).to have_http_status(:success)
      end

      it "displays the user's recipes as links" do
        expect(response.body).to include('<h2 class="section-title">Your Recipes</h2>')
        expect(response.body).to include(recipe.title)
        expect(response.body).to include("/recipes/#{recipe.id}")
      end

      it "displays the user's favorites with author" do
        expect(response.body).to include('<h2 class="section-title">Your Favorites</h2>')
        expect(response.body).to include(favorite.recipe.title)
        expect(response.body).to include(favorite.recipe.user.username)
        expect(response.body).to include("/recipes/#{favorite.recipe.id}")
      end

      it "displays the user's reviews with truncated content and recipe link" do
        expect(response.body).to include('<h2 class="section-title">Your Reviews</h2>')
        expect(response.body).to include(review.recipe.title)
        expect(response.body).to include("/recipes/#{review.recipe.id}")

        truncated = ActionController::Base.helpers.truncate(review.content, length: 50)
        expect(response.body).to include(truncated)
      end
    end

    context "when the user has no recipes, favorites, or reviews" do
      let(:empty_user) { User.create!(username: "Empty User", email: "empty@example.com", password: "password") }

      before do
        post login_path, params: { email: empty_user.email, password: "password" }
        get dashboard_path
      end

      it "shows no recipes message with link to create one" do
        expect(response.body).to include("You haven’t added any recipes yet.")
        expect(response.body).to include(new_recipe_path)
      end

      it "shows no favorites message" do
        expect(response.body).to include("You have no favorites yet.")
      end

      it "shows no reviews message" do
        expect(response.body).to include("You haven’t added any reviews yet.")
      end
    end

    context "when the user is not logged in" do
      before { get dashboard_path }

      it "redirects to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "shows login prompt message" do
        follow_redirect!
        expect(response.body).to include("Please log in first")
      end
    end
  end
end
