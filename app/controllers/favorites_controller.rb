class FavoritesController < ApplicationController
  before_action :set_favorite, only: [ :show, :edit, :update, :destroy ]

  def index
    @favorites = Favorite.all
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
    @favorite.user = User.first # Assign user manually for now
    if @favorite.save
      redirect_to @favorite, notice: "Favorite was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_form_data if @favorite
  end

  def update
    if @favorite&.update(favorite_params)
      redirect_to @favorite, notice: "Favorite was successfully updated."
    elsif @favorite
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @favorite
      @favorite.destroy
      redirect_to favorites_path, notice: "Favorite was successfully deleted."
    else
      redirect_to favorites_path, alert: "Favorite not found."
    end
  end

  private

  def set_favorite
    @favorite = Favorite.find(params[:id])
  end

  def set_form_data
    @recipes = Recipe.all
    @users = User.all
  end

  def favorite_params
    params.require(:favorite).permit(:user_id, :recipe_id)
  end
end
