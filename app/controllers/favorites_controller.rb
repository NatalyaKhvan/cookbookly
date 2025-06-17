class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_favorite, only: [ :destroy ]

  def index
    @favorites = current_user.favorites.includes(recipe: [ :user, :categories ])
  end

  def create
    recipe = Recipe.find(params[:recipe_id])

    if recipe.user == current_user
      redirect_to recipe, alert: "You cannot favorite your own recipe."
    else
      current_user.favorites.find_or_create_by(recipe: recipe)
      redirect_to recipe, notice: "Recipe was added to your favorites."
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(id: params[:id])
    if @favorite
      recipe = @favorite.recipe
      @favorite.destroy
      redirect_to recipe_path(recipe), notice: "Removed from favorites."
    else
      redirect_to recipes_path, alert: "You do not have permission to remove this favorite."
    end
  end

  private

  def set_favorite
    @favorite = current_user.favorites.find_by(id: params[:id])
  end
end
