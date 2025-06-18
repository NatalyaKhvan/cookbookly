require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) do
    User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  describe "GET /users" do
    before { post login_path, params: { email: user.email, password: "password" } }

    it "redirects to root with access denied alert" do
      get users_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access denied.")
    end
  end

  describe "GET /users/:id" do
    before { post login_path, params: { email: user.email, password: "password" } }

    it "shows the user" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testuser")
    end

    it "raises ActiveRecord::RecordNotFound when user does not exist" do
      get user_path(id: 999_999)
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
    context "with valid data" do
      it "creates a new user and redirects to root" do
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
    end

    context "with invalid data" do
      it "renders :new with unprocessable_entity status" do
        post users_path, params: {
          user: {
            username: "",
            email: "bademail",
            password: "pass",
            password_confirmation: "no_match"
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
      end
    end
  end

  describe "PATCH /users/:id" do
    before { post login_path, params: { email: user.email, password: "password" } }

    context "with valid data" do
      it "updates the user and redirects to user show page" do
        patch user_path(user), params: { user: { username: "updateduser" } }
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("updateduser")
      end
    end

    context "with invalid data" do
      it "renders :edit with unprocessable_entity status" do
        patch user_path(user), params: { user: { username: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/:id" do
    before { post login_path, params: { email: user.email, password: "password" } }

    it "deletes the user and redirects to root" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end
