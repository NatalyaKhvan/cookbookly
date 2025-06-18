require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create(username: "testuser", email: "test@example.com", password: "password") }

  describe "GET /login" do
    it "renders the login form" do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log In")
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "logs in the user and redirects to dashboard with notice" do
        post login_path, params: { email: user.email, password: "password" }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(response.body).to include("Logged in successfully")
      end
    end

    context "with invalid credentials" do
      it "re-renders the login form with alert and status 422" do
        post login_path, params: { email: user.email, password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid email or password")
      end
    end
  end

  describe "DELETE /logout" do
    it "clears session and redirects to root with notice" do
      post login_path, params: { email: user.email, password: "password" }
      expect(session[:user_id]).to eq(user.id)

      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Logged out successfully")
    end

    it "redirects to root with notice even if not logged in" do
      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Logged out successfully")
    end
  end

  context "when already logged in" do
    before do
      post login_path, params: { email: user.email, password: "password" }
    end

    it "redirects GET /login to dashboard" do
      get login_path
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects POST /login to dashboard" do
      post login_path, params: { email: user.email, password: "password" }
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
