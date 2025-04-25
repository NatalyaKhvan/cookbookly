require 'rails_helper'

RSpec.describe "Users", type: :request do
    let!(:user) { User.create!(username: "testuser", email: "test@example.com") }

  describe "GET /users" do
    it "returns a successful response" do
      get users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testuser")
    end
  end

  describe "GET /users/:id" do
    it "shows the user" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testuser")
    end

    it "returns 404 when no user exists" do
      get user_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end
  end
end