class Recipe < ApplicationRecord
    belongs_to :user

    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :ingredient_recipes, dependent: :destroy
    has_many :ingredients, through: :ingredient_recipes
    has_many :category_recipes, dependent: :destroy
    has_many :categories, through: :category_recipes

    validates :title, presence: true
    validates :instructions, presence: true

    accepts_nested_attributes_for :ingredient_recipes, allow_destroy: true

    def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating).to_f.round(2)
  end

    scope :search_by_title, ->(query) {
      where("LOWER(title) LIKE ?", "%#{query.downcase}%") if query.present?
    }

    scope :by_category, ->(category_id) {
      joins(:categories).where(categories: { id: category_id }) if category_id.present?
    }

    scope :by_ingredient, ->(ingredient_id) {
      joins(:ingredients).where(ingredients: { id: ingredient_id }) if ingredient_id.present?
    }
end
