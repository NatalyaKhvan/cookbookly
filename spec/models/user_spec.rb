require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many recipes" do
      assoc = User.reflect_on_association(:recipes)
      expect(assoc.macro).to eq :has_many
    end

    it "has many reviews" do
      assoc = User.reflect_on_association(:reviews)
      expect(assoc.macro).to eq :has_many
    end

    it "has many favorites" do
      assoc = User.reflect_on_association(:favorites)
      expect(assoc.macro).to eq :has_many
    end

    it "has many favorite_recipes through favorites" do
      assoc = User.reflect_on_association(:favorite_recipes)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq(:favorites)
      expect(assoc.options[:source]).to eq(:recipe)
    end
  end

  describe "validations" do
    it "is invalid without a username" do
      user = User.new(username: nil, email: "test@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "is invalid with a short username" do
      user = User.new(username: "ab", email: "test@example.com", password: "password")
      user.validate
      expect(user.errors[:username]).to include("is too short (minimum is 3 characters)")
    end

    it "is invalid without an email" do
      user = User.new(username: "tester", email: nil, password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an incorrect email format" do
      user = User.new(username: "tester", email: "invalid_email", password: "password")
      user.validate
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is invalid with a short password" do
      user = User.new(username: "tester", email: "test@example.com", password: "123")
      user.validate
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "is valid with all correct attributes" do
      user = User.new(username: "tester", email: "test@example.com", password: "password")
      expect(user).to be_valid
    end
  end

  describe "password authentication" do
    it "authenticates with correct password" do
      user = User.create(username: "user1", email: "user1@example.com", password: "password123")
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with wrong password" do
      user = User.create(username: "user2", email: "user2@example.com", password: "password123")
      expect(user.authenticate("wrongpass")).to be false
    end
  end

  describe "dependent destroy" do
    it "deletes associated recipes when user is deleted" do
      user = User.create!(username: "tester", email: "test@example.com", password: "password")
      user.recipes.create!(title: "Sample", instructions: "Do something")

      expect { user.destroy }.to change { Recipe.count }.by(-1)
    end

    it "deletes associated reviews when user is deleted" do
      user = User.create!(username: "tester", email: "test@example.com", password: "password")
      recipe = user.recipes.create!(title: "Sample", instructions: "Do something")
      recipe.reviews.create!(content: "Nice", rating: 4, user: user)

      expect { user.destroy }.to change { Review.count }.by(-1)
    end

    it "deletes associated favorites when user is deleted" do
      user = User.create!(username: "tester", email: "test@example.com", password: "password")
      recipe = user.recipes.create!(title: "Sample", instructions: "Do something")
      user.favorites.create!(recipe: recipe)

      expect { user.destroy }.to change { Favorite.count }.by(-1)
    end
  end
end
