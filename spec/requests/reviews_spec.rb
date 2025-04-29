require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake", instructions: "Mix and bake.", user: user) }
  let!(:review) { Review.create!(content: "Great!", rating: 5, user: user, recipe: recipe) }

  describe "GET /reviews" do
    it "returns a successful response and lists reviews" do
      get reviews_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Review for Chocolate Cake")
      expect(response.body).to include("5 stars")
    end
  end

  describe "GET /reviews/:id" do
    it "shows a review" do
      get review_path(review)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Great!")
      expect(response.body).to include("Rating:")
      expect(response.body).to include("Chocolate Cake")
    end

    it "returns 404 when no review exists" do
      get review_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
