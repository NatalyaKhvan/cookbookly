require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:category) { Category.create!(name: "Desserts") }

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /categories" do
    it "returns a list of categories" do
      get categories_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Desserts")
    end
  end

  describe "GET /categories/:id" do
    context "when category exists" do
      it "returns the category with recipes" do
        get category_path(category)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Desserts")
      end
    end

    context "when category does not exist" do
      it "returns 404 not found" do
        get category_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /categories/new" do
    it "renders the new form" do
      get new_category_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Save Category")
    end
  end

  describe "GET /categories/:id/edit" do
    it "renders the edit form" do
      get edit_category_path(category)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Save Category")
    end
  end

  describe "POST /categories" do
    context "with valid attributes" do
      it "creates a new category and redirects to show" do
        expect {
          post categories_path, params: { category: { name: "Appetizers" } }
        }.to change(Category, :count).by(1)
        expect(response).to redirect_to(category_path(Category.last))
        follow_redirect!
        expect(response.body).to include("Appetizers")
      end
    end

    context "with invalid attributes" do
      it "does not create a category and renders new with unprocessable_entity" do
        expect {
          post categories_path, params: { category: { name: "" } }
        }.not_to change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Save Category")
      end
    end
  end

  describe "PATCH /categories/:id" do
    context "with valid data" do
      it "updates the category and redirects to show" do
        patch category_path(category), params: { category: { name: "Breakfast" } }
        expect(response).to redirect_to(category_path(category))
        follow_redirect!
        expect(response.body).to include("Breakfast")
      end
    end

    context "with invalid data" do
      it "does not update the category and renders edit with unprocessable_entity" do
        patch category_path(category), params: { category: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Save Category")
      end
    end
  end

  describe "DELETE /categories/:id" do
    context "when category has no recipes" do
      it "deletes the category and redirects to index" do
        expect {
          delete category_path(category)
        }.to change(Category, :count).by(-1)
        expect(response).to redirect_to(categories_path)
        follow_redirect!
        expect(response.body).to include("All Categories")
      end
    end

    context "when category has recipes" do
      before do
        category.recipes.create!(title: "Test Recipe", instructions: "Mix", user: user)
      end

      it "does not delete category and redirects with alert" do
        expect {
          delete category_path(category)
        }.not_to change(Category, :count)
        expect(response).to redirect_to(categories_path)
        follow_redirect!
        expect(response.body).to include("Cannot delete category assigned to recipes.")
      end
    end

    context "when category does not exist" do
      it "returns 404 not found" do
        delete category_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
