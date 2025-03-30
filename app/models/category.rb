class Category < ApplicationRecord

    has_many :category_recipes
    has_many :recipes, through: :category_recipes
end