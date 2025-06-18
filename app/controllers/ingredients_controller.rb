class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login, except: [ :index, :show ]

  def index
    @ingredients = Ingredient.all
  end

  def show
  end

  def new
    @ingredient = Ingredient.new

    return_to_recipe_id = params[:return_to_recipe_id].to_i

    if return_to_recipe_id > 0 && Recipe.exists?(return_to_recipe_id)
      @return_to = recipe_path(return_to_recipe_id)
    else
      @return_to = safe_return_to_path(params[:return_to])  # << Using new safe method here
    end
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      if params[:return_to_recipe_id].present?
        redirect_to new_recipe_ingredient_recipe_path(params[:return_to_recipe_id], new_ingredient_id: @ingredient.id),
                  notice: "Ingredient created! Now you can add it to the recipe."
      else
        redirect_to ingredients_path, notice: "Ingredient created!"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to @ingredient, notice: "Ingredient was successfully updated." }
        format.turbo_stream { redirect_to @ingredient, notice: "Ingredient was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "form_container",
            partial: "ingredients/form",
            locals: { ingredient: @ingredient }
          ), status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    if @ingredient.recipes.exists?
      redirect_to ingredients_path, alert: "Cannot delete ingredient still used in recipes."
    else
      @ingredient.destroy
      redirect_to ingredients_path, notice: "Ingredient was successfully deleted."
    end
  end

  private

  def safe_return_to_path(path)
    return nil if path.blank?

    # Accept only paths starting with "/" (internal relative paths)
    path.start_with?("/") ? path : nil
  end

  def set_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
    unless @ingredient
      redirect_to ingredients_path, alert: "Ingredient not found."
    end
  end

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
