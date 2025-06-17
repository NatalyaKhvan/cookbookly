require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when recipes exist" do
      before do
        10.times do |i|
          user = User.create!(username: "User#{i}", email: "user#{i}@example.com", password: "password")
          Recipe.create!(title: "Recipe #{i + 1}", instructions: "Do something #{i + 1}", user: user)
        end
        get root_path
      end

      it "renders successfully" do
        expect(response).to have_http_status(:success)
      end

      it "shows welcome intro text" do
        expect(response.body).to include("Welcome to Cookbookly!")
        expect(response.body).to include("Explore tasty recipes, favorite your finds, and share your own.")
      end

      it "displays 'Browse Recipes' button linking to recipes index" do
        expect(response.body).to include('Browse Recipes')
        expect(response.body).to include(recipes_path)
      end

      it "limits displayed recipes to 5" do
        expect(response.body).to include("Recipe 1")
        expect(response.body).to include("Recipe 5")
        expect(response.body).not_to include("Recipe 6")
      end

      it "shows each recipe's average rating or 'No ratings yet'" do
        expect(response.body).to include("No ratings yet")
      end

      it "displays recipe titles with links to show pages" do
        Recipe.limit(5).each do |recipe|
          expect(response.body).to include(recipe.title)
          expect(response.body).to include(recipe_path(recipe))
        end
      end

      it "shows average rating when at least one review exists" do
        recipe = Recipe.first
        user = recipe.user
        Review.create!(rating: 4, content: "Nice!", recipe: recipe, user: user)

        get root_path
        expect(response.body).to include("4.0 / 5")
      end
    end

    context "when no recipes exist" do
      before { get root_path }

      it "shows no featured recipes message with link to browse all recipes" do
        expect(response.body).to include("No featured recipes yet.")
        expect(response.body).to include(recipes_path)
      end
    end

    context "when user is logged in" do
      let!(:user) { User.create!(username: "LoggedInUser", email: "user@example.com", password: "password") }

      before do
        post login_path, params: { email: user.email, password: "password" }
        get root_path
      end

      it "shows welcome back message with username" do
        expect(response.body).to include("Welcome back, #{user.username}!")
      end

      it "shows links to dashboard and logout" do
        expect(response.body).to include(dashboard_path)
        expect(response.body).to include(logout_path)
      end
    end

    context "when user is not logged in" do
      before { get root_path }

      it "shows signup and login links" do
        expect(response.body).to include(new_user_path)
        expect(response.body).to include(login_path)
      end

      it "shows guest message" do
        expect(response.body).to include("Not a member yet?")
      end
    end
  end
end
