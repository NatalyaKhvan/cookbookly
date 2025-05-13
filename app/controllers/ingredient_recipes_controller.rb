class IngredientRecipesController < ApplicationController
  before_action :set_ingredient_recipe, only: [ :show, :update, :destroy ]

  def index
    @ingredient_recipes = IngredientRecipe.all
  end

  def show; end

  def create
    @ingredient_recipe = IngredientRecipe.new(ingredient_recipe_params)
    if @ingredient_recipe.save
      redirect_to @ingredient_recipe, notice: "Ingredient recipe was successfully created."
    else
      @ingredient_recipes = IngredientRecipe.all
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @ingredient_recipe.update(ingredient_recipe_params)
      redirect_to @ingredient_recipe, notice: "Ingredient recipe was successfully updated."
    else
      @ingredient_recipes = IngredientRecipe.all
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient_recipe.destroy
    redirect_to ingredient_recipes_path, notice: "Ingredient recipe was successfully deleted."
  end

  private

  def set_ingredient_recipe
    @ingredient_recipe = IngredientRecipe.find(params[:id])
  end

  def ingredient_recipe_params
    params.require(:ingredient_recipe).permit(:recipe_id, :ingredient_id, :quantity, :unit)
  end
end
