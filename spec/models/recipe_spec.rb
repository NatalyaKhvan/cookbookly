require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let!(:user) { User.create!(username: "tester", email: "test@example.com", password: "password") }
  let!(:category) { Category.create!(name: "Desserts") }
  let!(:ingredient) { Ingredient.create!(name: "Sugar") }

  describe "associations" do
    it "belongs to a user" do
      assoc = Recipe.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "has many reviews" do
      assoc = Recipe.reflect_on_association(:reviews)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many favorites" do
      assoc = Recipe.reflect_on_association(:favorites)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many ingredient_recipes" do
      assoc = Recipe.reflect_on_association(:ingredient_recipes)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many ingredients through ingredient_recipes" do
      assoc = Recipe.reflect_on_association(:ingredients)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:ingredient_recipes)
    end

    it "has many category_recipes" do
      assoc = Recipe.reflect_on_association(:category_recipes)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many categories through category_recipes" do
      assoc = Recipe.reflect_on_association(:categories)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:category_recipes)
    end
  end

  describe "validations" do
    it "is invalid without a title" do
      recipe = Recipe.new(title: nil, instructions: "Mix all ingredients", user: user)
      expect(recipe).not_to be_valid
      expect(recipe.errors[:title]).to include("can't be blank")
    end

    it "is invalid without instructions" do
      recipe = Recipe.new(title: "Tasty Soup", instructions: nil, user: user)
      expect(recipe).not_to be_valid
      expect(recipe.errors[:instructions]).to include("can't be blank")
    end

    it "is valid with a title and instructions" do
      recipe = Recipe.new(title: "Tasty Soup", instructions: "Mix all", user: user)
      expect(recipe).to be_valid
    end
  end

  describe "#average_rating" do
    let!(:recipe) { Recipe.create!(title: "Tasty", instructions: "Boil", user: user) }

    it "returns 0 if there are no reviews" do
      expect(recipe.average_rating).to eq(0)
    end

    it "returns the average rating rounded to two decimals" do
      recipe.reviews.create!(rating: 4, content: "Good", user: user)
      recipe.reviews.create!(rating: 5, content: "Excellent", user: user)

      expect(recipe.average_rating).to eq(4.5)
    end
  end

  describe "dependent destroy" do
    let!(:recipe) { Recipe.create!(title: "Soup", instructions: "Boil water", user: user) }

    it "deletes associated reviews when recipe is deleted" do
      Review.create!(content: "Great!", rating: 5, user: user, recipe: recipe)
      expect { recipe.destroy }.to change { Review.count }.by(-1)
    end

    it "deletes associated ingredient_recipes when recipe is deleted" do
      IngredientRecipe.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit: "tsp")
      expect { recipe.destroy }.to change { IngredientRecipe.count }.by(-1)
    end

    it "deletes associated favorites when recipe is deleted" do
      Favorite.create!(user: user, recipe: recipe)
      expect { recipe.destroy }.to change { Favorite.count }.by(-1)
    end

    it "deletes associated category_recipes when recipe is deleted" do
      CategoryRecipe.create!(recipe: recipe, category: category)
      expect { recipe.destroy }.to change { CategoryRecipe.count }.by(-1)
    end
  end

  describe "scopes" do
    let!(:recipe1) { Recipe.create!(title: "Chocolate Cake", instructions: "Bake", user: user, categories: [ category ]) }
    let!(:recipe2) { Recipe.create!(title: "Fruit Salad", instructions: "Mix", user: user) }

    before do
      IngredientRecipe.create!(recipe: recipe1, ingredient: ingredient, quantity: 1, unit: "cup")
    end

    it "filters by title (case insensitive)" do
      expect(Recipe.search_by_title("chocolate")).to include(recipe1)
      expect(Recipe.search_by_title("chocolate")).not_to include(recipe2)
    end

    it "filters by category" do
      expect(Recipe.by_category(category.id)).to include(recipe1)
      expect(Recipe.by_category(category.id)).not_to include(recipe2)
    end

    it "filters by ingredient" do
      expect(Recipe.by_ingredient(ingredient.id)).to include(recipe1)
      expect(Recipe.by_ingredient(ingredient.id)).not_to include(recipe2)
    end
  end
end
