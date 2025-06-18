require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake", instructions: "Mix and bake.", user: user) }
  let!(:review) { Review.create(content: "Great recipe!", rating: 5, recipe: recipe, user: user) }

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /recipes/:recipe_id/reviews" do
    it "returns a successful response and lists reviews" do
      get recipe_reviews_path(recipe)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Great recipe!")
      expect(response.body).to include("5 stars")
    end
  end

  describe "GET /recipes/:recipe_id/reviews/:id" do
    context "when the review exists" do
      it "returns a successful response" do
        get recipe_review_path(recipe, review)
        expect(response).to have_http_status(200)
      end
    end

    context "when the review does not exist" do
      it "returns a 404 not found" do
        get recipe_review_path(recipe, id: 'nonexistent')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /recipes/:recipe_id/reviews" do
    context "with valid attributes" do
      it "creates a new review and redirects" do
        expect {
          post recipe_reviews_path(recipe), params: {
            review: {
              content: "Delicious!",
              rating: 4
            }
          }
        }.to change { Review.count }.by(1)

        expect(response).to redirect_to(recipe_review_path(recipe, Review.last))
      end
    end

    context "with invalid attributes" do
      it "does not create a new review" do
        expect {
          post recipe_reviews_path(recipe), params: {
            review: {
              content: "",
              rating: "abc"
            }
          }
        }.not_to change { Review.count }

        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      end
    end
  end

  describe "PUT /recipes/:recipe_id/reviews/:id" do
    it "updates the review and redirects" do
      put recipe_review_path(recipe, review), params: {
        review: {
          content: "Updated review"
        }
      }

      expect(response).to redirect_to(recipe_review_path(recipe, review))
      review.reload
      expect(review.content).to eq("Updated review")
    end
  end

  describe "DELETE /recipes/:recipe_id/reviews/:id" do
    it "deletes the review" do
      expect {
        delete recipe_review_path(recipe, review)
      }.to change { Review.count }.by(-1)

      expect(response).to redirect_to(recipe_reviews_path(recipe))
    end
  end
end
