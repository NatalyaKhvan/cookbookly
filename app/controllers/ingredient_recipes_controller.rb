class IngredientRecipesController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_collections, only: [ :new, :edit, :create, :update ]
  before_action :set_recipe, only: [ :new, :create ]
  before_action :set_ingredient_recipe, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :new, :create ]
  before_action :authorize_recipe_owner!, only: [ :edit, :update, :destroy ]

  def index
    @ingredients = current_user.ingredients.order(:name)
  end

  def new
    @ingredient_recipe = @recipe.ingredient_recipes.build
    if params[:new_ingredient_id].present?
      @ingredient_recipe.ingredient_id = params[:new_ingredient_id]
    end
  end

  def edit
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = Ingredient.all.order(:name)
  end

  def create
    @ingredient_recipe = @recipe.ingredient_recipes.new(ingredient_recipe_params.except(:recipe_id))

    if @ingredient_recipe.save
      redirect_to recipe_path(@recipe), notice: "Ingredient was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ingredient_recipe.update(ingredient_recipe_params)
      redirect_to recipe_path(@ingredient_recipe.recipe), notice: "Ingredient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = @ingredient_recipe.recipe
    @ingredient_recipe.destroy
    redirect_to recipe_path(recipe), notice: "Ingredient was successfully removed."
  end

  private

  def set_ingredient_recipe
    @ingredient_recipe = IngredientRecipe.find(params[:id])
  end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_collections
    @ingredients = Ingredient.all
    @recipes = Recipe.all
  end

  def ingredient_recipe_params
    params.require(:ingredient_recipe).permit(:recipe_id, :ingredient_id, :quantity, :unit)
  end

  def authorize_user!
    recipe = @recipe || Recipe.find_by(id: params[:recipe_id] || params.dig(:ingredient_recipe, :recipe_id))

    if recipe.nil? || recipe.user != current_user
      redirect_to recipe_path(recipe || Recipe.new), alert: "You do not have permission to modify ingredients for this recipe."
    end
  end

  def authorize_recipe_owner!
    unless @ingredient_recipe.recipe.user == current_user
      redirect_to recipe_path(@ingredient_recipe.recipe), alert: "You're not authorized to edit this."
    end
  end
end
