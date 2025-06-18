require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:other_user) { User.create!(username: "otheruser", email: "other@example.com", password: "password") }
  let!(:recipe) { Recipe.create!(title: "Chocolate Cake", instructions: "Mix and bake.", user: user) }
  let!(:review) { Review.create!(content: "Great recipe!", rating: 5, recipe: recipe, user: user) }

  def login(user)
    post login_path, params: { email: user.email, password: "password" }
    follow_redirect! if response.redirect?
  end

  describe "GET /recipes/:recipe_id/reviews" do
    before { login(user) }

    it "returns a successful response and lists reviews with correct stars" do
      get recipe_reviews_path(recipe)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Great recipe!")
      expect(response.body.scan('<span class="star full">★</span>').size).to eq(5)
    end
  end

  describe "GET /recipes/:recipe_id/reviews/:id" do
    before { login(user) }

    context "when the review exists" do
      it "shows the review" do
        get recipe_review_path(recipe, review)
        expect(response).to have_http_status(200)
        expect(response.body).to include("Great recipe!")
        expect(response.body).to include("5")
      end
    end

    context "when the review does not exist" do
      it "returns 404 not found" do
        get recipe_review_path(recipe, id: 9999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /recipes/:recipe_id/reviews/new" do
    context "when logged in" do
      before { login(user) }

      it "allows access if user has not reviewed" do
        # Temporarily destroy existing review for this test
        review.destroy
        get new_recipe_review_path(recipe)
        expect(response).to have_http_status(200)
      end

      it "redirects if user already reviewed" do
        get new_recipe_review_path(recipe)
        expect(response).to redirect_to(recipe_path(recipe))
        follow_redirect!
        expect(response.body).to include("You have already reviewed this recipe.")
      end
    end

    it "redirects unauthenticated users" do
      get new_recipe_review_path(recipe)
      expect(response).to redirect_to(login_path)
    end
  end

  describe "POST /recipes/:recipe_id/reviews" do
    context "when logged in" do
      before { login(user) }

      context "with valid parameters" do
        before { review.destroy } # Ensure user hasn't reviewed yet

        it "creates a new review and redirects" do
          expect {
            post recipe_reviews_path(recipe), params: { review: { content: "Awesome!", rating: 4 } }
          }.to change(Review, :count).by(1)

          expect(response).to redirect_to(recipe_review_path(recipe, Review.last))
          follow_redirect!
          expect(response.body).to include("Review was successfully created.")
        end
      end

      context "with invalid parameters" do
        before { review.destroy }

        it "does not create review and renders error" do
          expect {
            post recipe_reviews_path(recipe), params: { review: { content: "", rating: nil } }
          }.not_to change(Review, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Please fix the")
          expect(response.body).to include("Content can&#39;t be blank")
        end
      end

      context "when user already reviewed" do
        it "does not create a new review and redirects with alert" do
          expect {
            post recipe_reviews_path(recipe), params: { review: { content: "Another review", rating: 4 } }
          }.not_to change(Review, :count)

          expect(response).to redirect_to(recipe_path(recipe))
          follow_redirect!
          expect(response.body).to include("You have already reviewed this recipe.")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post recipe_reviews_path(recipe), params: { review: { content: "Awesome!", rating: 4 } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /recipes/:recipe_id/reviews/:id/edit" do
    context "when logged in" do
      it "allows owner to access edit" do
        login(user)
        get edit_recipe_review_path(recipe, review)
        expect(response).to have_http_status(200)
      end

      it "blocks non-owners from editing" do
        login(other_user)
        get edit_recipe_review_path(recipe, review)
        expect(response).to redirect_to(recipe_reviews_path(recipe))
        follow_redirect!
        expect(response.body).to include("You do not have permission to modify this review.")
      end
    end

    it "redirects unauthenticated users" do
      get edit_recipe_review_path(recipe, review)
      expect(response).to redirect_to(login_path)
    end
  end

  describe "PATCH /recipes/:recipe_id/reviews/:id" do
    context "as the owner" do
      before { login(user) }

      it "updates the review" do
        patch recipe_review_path(recipe, review), params: { review: { content: "Updated content", rating: 3 } }
        expect(response).to redirect_to(recipe_review_path(recipe, review))
        follow_redirect!
        expect(response.body).to include("Review was successfully updated.")
        expect(review.reload.content).to eq("Updated content")
      end
    end

    context "as a non-owner" do
      before { login(other_user) }

      it "does not allow update" do
        patch recipe_review_path(recipe, review), params: { review: { content: "Hacked!", rating: 1 } }
        expect(response).to redirect_to(recipe_reviews_path(recipe))
        follow_redirect!
        expect(response.body).to include("You do not have permission to modify this review.")
        expect(review.reload.content).not_to eq("Hacked!")
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        patch recipe_review_path(recipe, review), params: { review: { content: "No login", rating: 2 } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /recipes/:recipe_id/reviews/:id" do
    context "as the owner" do
      before { login(user) }

      it "deletes the review" do
        expect {
          delete recipe_review_path(recipe, review)
        }.to change(Review, :count).by(-1)

        expect(response).to redirect_to(recipe_reviews_path(recipe))
        follow_redirect!
        expect(response.body).to include("Review was successfully deleted.")
      end
    end

    context "as a non-owner" do
      before { login(other_user) }

      it "does not delete the review" do
        expect {
          delete recipe_review_path(recipe, review)
        }.not_to change(Review, :count)

        expect(response).to redirect_to(recipe_reviews_path(recipe))
        follow_redirect!
        expect(response.body).to include("You do not have permission to modify this review.")
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        delete recipe_review_path(recipe, review)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
