class ReviewsController < ApplicationController
  before_action :set_recipe
  before_action :set_review, only: [ :show, :update, :destroy ]

  def index
    @reviews = @recipe.reviews
  end

  def show
  end

  def create
    @review = @recipe.reviews.new(review_params)
    @review.user = User.first  # Assign user manually for now

    if @review.save
      redirect_to recipe_reviews_path(@recipe, @review), notice: "Review was successfully created."
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to recipe_review_path(@recipe, @review), notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to recipe_reviews_url(@recipe), notice: "Review was successfully deleted."
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_review
    @review = @recipe.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
