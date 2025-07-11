class User < ApplicationRecord
    has_secure_password

    has_many :recipes, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorite_recipes, through: :favorites, source: :recipe

    validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

    def favorited?(recipe)
        favorites.exists?(recipe_id: recipe.id)
    end

    def favorite_for(recipe)
        favorites.find_by(recipe_id: recipe.id)
    end
end
