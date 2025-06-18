require 'rails_helper'

RSpec.describe "Users", type: :request do
    let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password",
    password_confirmation: "password") }

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

  describe "GET /users/new" do
    it "renders the new user form" do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users" do
    it "creates a new user with valid data" do
      expect {
        post users_path, params: {
          user: {
            username: "newuser",
            email: "new@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    it "renders :new with invalid data" do
      post users_path, params: {
        user: {
          username: "",
          email: "bad",
          password: "pass",
          password_confirmation: "no_match"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /users/:id" do
    before { post login_path, params: { email: user.email, password: "password" } }

    it "updates the user with valid data" do
      patch user_path(user), params: {
        user: { username: "updateduser" }
      }
      expect(response).to redirect_to(user_path(user))
      follow_redirect!
      expect(response.body).to include("updateduser")
    end

    it "renders :edit with invalid data" do
      patch user_path(user), params: {
        user: { username: "" }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /users/:id" do
    before { post login_path, params: { email: user.email, password: "password" } }

    it "deletes the user" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end
