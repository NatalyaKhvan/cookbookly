require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:category) { Category.create!(name: "Desserts") }

  describe "GET /categories" do
    it "returns a successful response" do
      get categories_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Desserts")
    end
  end

  describe "GET /categories/:id" do
    it "shows the category and its recipes" do
      get category_path(category)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Desserts")
    end

    it "returns 404 when no category exists" do
      get category_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
