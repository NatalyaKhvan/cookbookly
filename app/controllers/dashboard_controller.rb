class DashboardController < ApplicationController
  before_action :require_login

  def index
    @recipes = current_user.recipes
    @favorites = current_user.favorites.includes(:recipe)
    @reviews = current_user.reviews.includes(:recipe)
  end
end
