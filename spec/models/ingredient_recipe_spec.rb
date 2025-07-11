require 'rails_helper'

RSpec.describe IngredientRecipe, type: :model do
  describe "associations" do
    it "belongs to recipe" do
      assoc = IngredientRecipe.reflect_on_association(:recipe)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to ingredient" do
      assoc = IngredientRecipe.reflect_on_association(:ingredient)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:user) { User.create(username: "user", email: "user@example.com", password: "password") }
    let(:recipe) { Recipe.create(title: "Test Recipe", instructions: "Some instructions", user: user) }
    let(:ingredient) { Ingredient.create(name: "Sugar") }

    it "is valid with quantity and unit" do
      ingredient_recipe = IngredientRecipe.new(quantity: 100, unit: "grams", recipe: recipe, ingredient: ingredient)
      expect(ingredient_recipe).to be_valid
    end

    it "is invalid without quantity" do
      ingredient_recipe = IngredientRecipe.new(quantity: nil, unit: "grams", recipe: recipe, ingredient: ingredient)
      expect(ingredient_recipe).not_to be_valid
      expect(ingredient_recipe.errors[:quantity]).to include("can't be blank")
    end

    it "is invalid with non-positive quantity" do
      ingredient_recipe = IngredientRecipe.new(quantity: 0, unit: "grams", recipe: recipe, ingredient: ingredient)
      expect(ingredient_recipe).not_to be_valid
      expect(ingredient_recipe.errors[:quantity]).to include("must be greater than 0")
    end

    it "is invalid without unit" do
      ingredient_recipe = IngredientRecipe.new(quantity: 100, unit: nil, recipe: recipe, ingredient: ingredient)
      expect(ingredient_recipe).not_to be_valid
      expect(ingredient_recipe.errors[:unit]).to include("can't be blank")
    end

    it "is invalid without recipe" do
      ingredient_recipe = IngredientRecipe.new(quantity: 100, unit: "grams", recipe: nil, ingredient: ingredient)
      expect(ingredient_recipe).not_to be_valid
      expect(ingredient_recipe.errors[:recipe]).to include("must exist")
    end

    it "is invalid without ingredient" do
      ingredient_recipe = IngredientRecipe.new(quantity: 100, unit: "grams", recipe: recipe, ingredient: nil)
      expect(ingredient_recipe).not_to be_valid
      expect(ingredient_recipe.errors[:ingredient]).to include("must exist")
    end
  end
end
