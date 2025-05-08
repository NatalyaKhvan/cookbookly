require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:category) { Category.create(name: "Desserts") }

  describe "GET /categories" do
    it "returns a list of categories" do
      get categories_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Desserts")
    end
  end

  describe "GET /categories/:id" do
    context "when category exists" do
      it "returns the category" do
        get category_path(category)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Desserts")
      end
    end

    context "when category does not exist" do
      it "returns a not found error" do
        get category_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /categories" do
    context "with valid attributes" do
      it "creates a new category" do
        expect {
          post categories_path, params: { category: { name: "Appetizers" } }
        }.to change(Category, :count).by(1)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Appetizers")
      end
    end

    context "with invalid attributes" do
      it "does not create a category" do
        expect {
          post categories_path, params: { category: { name: "" } }
        }.not_to change(Category, :count)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /categories/:id" do
    context "with valid data" do
      it "updates the category" do
        patch category_path(category), params: { category: { name: "Breakfast" } }
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Breakfast")
      end
    end

    context "with invalid data" do
      it "does not update the category" do
        patch category_path(category), params: { category: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /categories/:id" do
    context "when category exists" do
      it "deletes the category" do
        expect {
          delete category_path(category)
        }.to change(Category, :count).by(-1)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
      end
    end

    context "when category does not exist" do
      it "returns a not found error" do
        delete category_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
