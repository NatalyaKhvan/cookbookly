class IngredientRecipesController < ApplicationController
    def index
      @ingredient_recipes = IngredientRecipe.all
    end

    def show
      @ingredient_recipe = IngredientRecipe.find(params[:id])
    end
end
