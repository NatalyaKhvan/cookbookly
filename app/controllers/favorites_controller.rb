class FavoritesController < ApplicationController
  before_action :set_favorite, only: [ :show, :edit, :update, :destroy ]

  def index
    @favorites = current_user.favorites
  end

  def show
    @recipe = @favorite.recipe
  end

  def new
    @favorite = Favorite.new
    set_form_data
  end

  def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user = current_user
    if @favorite.save
      redirect_to @favorite, notice: "Favorite was successfully created."
    else
      set_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_form_data
  end

  def update
    if @favorite.update(favorite_params)
      redirect_to @favorite, notice: "Favorite was successfully updated."
    else
      set_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite.destroy
    redirect_to favorites_path, notice: "Favorite was successfully deleted."
  end

  private

  def set_favorite
    @favorite = Favorite.find(params[:id])
  end

  def set_form_data
    @recipes = Recipe.all
  end

  def favorite_params
    params.require(:favorite).permit(:recipe_id)
  end
end
