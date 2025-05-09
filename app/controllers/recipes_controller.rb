class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :edit, :update, :destroy ]

  def index
    @recipes = Recipe.all
  end

  def show
    if @recipe
      @reviews = @recipe.reviews
    end
  end

  def new
    @recipe = Recipe.new
    @categories = Category.all
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = User.first # Assign user manually for now
    @categories = Category.all
    if @recipe.save
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @recipe
      @categories = Category.all
    end
  end

  def update
    @categories = Category.all
    if @recipe&.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated."
    elsif @recipe
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @recipe && @recipe.user == User.first
      @recipe.destroy
      redirect_to recipes_path, notice: "Recipe was successfully deleted."
    else
      redirect_to recipes_path, alert: "Recipe not found or you do not have permission to delete it."
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, category_ids: [])
  end
end
