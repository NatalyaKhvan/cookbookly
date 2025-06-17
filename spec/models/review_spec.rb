require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "associations" do
    it "belongs to a user" do
      assoc = Review.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a recipe" do
      assoc = Review.reflect_on_association(:recipe)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:user) { User.create!(username: "tester", email: "test@example.com", password: "password") }
    let(:recipe) { Recipe.create!(title: "Soup", instructions: "Boil water", user: user) }

    it "is invalid without content" do
      review = Review.new(content: nil, rating: 4, user: user, recipe: recipe)
      expect(review).not_to be_valid
      expect(review.errors[:content]).to include("can't be blank")
    end

    it "is invalid without rating" do
      review = Review.new(content: "Nice dish", rating: nil, user: user, recipe: recipe)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it "is invalid if rating is less than 1" do
      review = Review.new(content: "Bad", rating: 0, user: user, recipe: recipe)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("must be greater than 0")
    end

    it "is invalid if rating is more than 5" do
      review = Review.new(content: "Too good", rating: 6, user: user, recipe: recipe)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("must be less than or equal to 5")
    end

    it "is invalid if rating is not an integer" do
      review = Review.new(content: "Weird rating", rating: 3.5, user: user, recipe: recipe)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("must be an integer")
    end

    it "is valid with proper content and integer rating between 1 and 5" do
      review = Review.new(content: "Tasty!", rating: 5, user: user, recipe: recipe)
      expect(review).to be_valid
    end
  end
end
