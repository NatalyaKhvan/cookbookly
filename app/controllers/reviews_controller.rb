class ReviewsController < ApplicationController
  before_action :set_recipe
  before_action :set_review, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login, except: [ :index, :show ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @reviews = @recipe.reviews.includes(:user)
  end

  def show
  end

  def new
    if @recipe.reviews.exists?(user_id: current_user.id)
      redirect_to recipe_path(@recipe), alert: "You have already reviewed this recipe."
    else
      @review = @recipe.reviews.new
    end
  end

  def edit
  end

  def create
    if @recipe.reviews.exists?(user_id: current_user.id)
      redirect_to recipe_path(@recipe), alert: "You have already reviewed this recipe."
      return
    end

    @review = @recipe.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to recipe_review_path(@recipe, @review), notice: "Review was successfully created."
    else
      render :new, status: :unprocessable_entity
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
    redirect_to recipe_reviews_path(@recipe), notice: "Review was successfully deleted."
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

  def authorize_user!
    unless @review.user == current_user
      redirect_to recipe_reviews_path(@recipe), alert: "You do not have permission to modify this review."
    end
  end
end
