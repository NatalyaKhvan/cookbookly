require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "associations" do
    it "belongs to a user" do
      assoc = Favorite.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a recipe" do
      assoc = Favorite.reflect_on_association(:recipe)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:user) { User.create(username: "tester", email: "test@example.com", password: "password") }
    let(:recipe) { Recipe.create(title: "Delicious Pie", instructions: "Bake it", user: user) }

    it "is invalid without a user" do
      favorite = Favorite.new(recipe: recipe)
      expect(favorite).not_to be_valid
      expect(favorite.errors[:user]).to include("must exist")
    end

    it "is invalid without a recipe" do
      favorite = Favorite.new(user: user)
      expect(favorite).not_to be_valid
      expect(favorite.errors[:recipe]).to include("must exist")
    end

    it "is valid with a user and a recipe" do
      favorite = Favorite.new(user: user, recipe: recipe)
      expect(favorite).to be_valid
    end

    it "does not allow the same user to favorite the same recipe twice" do
      Favorite.create!(user: user, recipe: recipe)
      duplicate = Favorite.new(user: user, recipe: recipe)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:recipe_id]).to include("has already been taken")
    end
  end
end
