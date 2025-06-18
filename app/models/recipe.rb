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
end
