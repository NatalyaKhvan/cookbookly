require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "associations" do
    it "has many ingredient_recipes" do
      assoc = Ingredient.reflect_on_association(:ingredient_recipes)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many recipes through ingredient_recipes" do
      assoc = Ingredient.reflect_on_association(:recipes)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:ingredient_recipes)
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      ingredient = Ingredient.new(name: nil)
      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:name]).to include("can't be blank")
    end

    it "is invalid with duplicate name" do
      Ingredient.create!(name: "Salt")
      duplicate = Ingredient.new(name: "Salt")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("already exists in the list.")
    end

    it "is valid with a unique name" do
      ingredient = Ingredient.new(name: "Olive Oil")
      expect(ingredient).to be_valid
    end
  end

  describe "callbacks" do
    it "prevents deletion if ingredient is used in recipes" do
      user = User.create!(username: "tester", email: "test@example.com", password: "password")
      ingredient = Ingredient.create!(name: "Sugar")
      recipe = Recipe.create!(title: "Cake", instructions: "Mix and bake", user: user)
      IngredientRecipe.create!(ingredient: ingredient, recipe: recipe, quantity: 1, unit: "cup")

      expect { ingredient.destroy }.not_to change { Ingredient.count }
      expect(ingredient.errors[:base]).to include("Cannot delete ingredient still used in recipes.")
    end

    it "allows deletion if ingredient is not used in any recipe" do
      ingredient = Ingredient.create!(name: "Pepper")
      expect { ingredient.destroy }.to change { Ingredient.count }.by(-1)
    end
  end
end
