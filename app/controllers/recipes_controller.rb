class RecipesController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_recipe, only: [ :show, :edit, :update, :destroy ]
  before_action :set_categories, only: [ :new, :edit, :create, :update ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @recipes = Recipe.all
    @recipes = @recipes.search_by_title(params[:query])
                     .by_category(params[:category_id])
                     .by_ingredient(params[:ingredient_id])
                     .distinct
  end

  def show
    @reviews = @recipe.reviews.includes(:user).order(created_at: :desc).limit(3)
    @ingredients = Ingredient.all.order(:name)
    @user_review = @recipe.reviews.find_by(user_id: current_user.id) if current_user
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @recipe.destroy
      redirect_to recipes_path, notice: "Recipe was successfully deleted."
    else
      redirect_to recipes_path, alert: @recipe.errors.full_messages.to_sentence
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :instructions, category_ids: []
    )
  end

  def authorize_user!
    unless @recipe.user == current_user
      redirect_to recipes_path, alert: "You do not have permission to modify this recipe."
    end
  end
end
