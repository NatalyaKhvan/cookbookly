class User < ApplicationRecord
    has_many :recipes
    has_many :reviews
    has_many :favorites
    has_many :favorite_recipes, through: :favorites, source: :recipe
end
